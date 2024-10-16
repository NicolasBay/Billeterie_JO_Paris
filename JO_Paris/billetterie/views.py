from datetime import datetime, timedelta
from io import BytesIO
from django.conf import settings
from django.core.mail import EmailMessage
from django.contrib import messages
from django.contrib.auth import login, logout, get_user_model
from django.contrib.auth.views import LoginView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
from django.shortcuts import render, redirect, get_object_or_404
from django.template.loader import render_to_string
from django.urls import reverse_lazy, reverse
from django.utils.crypto import get_random_string
from django.utils.http import url_has_allowed_host_and_scheme
from django.utils.decorators import method_decorator
from django.views import View
from django.views.generic import TemplateView, ListView, FormView
from django.views.decorators.csrf import csrf_exempt
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.response import Response
from rest_framework import status
import jwt
import qrcode
import logging
import stripe

from .forms import SignupForm, AjouterAuPanierForm, CheckoutForm
from .models import Ticket, Transaction, Utilisateur


class SignupView(View):
    def get(self, request):
        form = SignupForm()
        return render(request, 'billetterie/login/signup.html', {'form': form})

    def post(self, request):
        form = SignupForm(request.POST)
        if form.is_valid():
            utilisateur = form.save()
            login(request, utilisateur)
            messages.success(request, 'Votre compte a été créé avec succès.')
            return redirect('home')
        return render(request, 'billetterie/login/signup.html', {'form': form})

    

class CustomTokenObtainPairView(TokenObtainPairView):
    """
     Une vue fournie par Django REST framework Simple JWT pour obtenir un nouveau jeton d’accès et un jeton de rafraîchissement. 
     Cette vue gère l’authentification des utilisateurs et la génération des jetons JWT.
    """
    pass


class CustomTokenRefreshView(TokenRefreshView):
    """Une vue pour rafraîchir un jeton d’accès en utilisant un jeton de rafraîchissement valide. 
    Cela permet de prolonger la session de l’utilisateur sans qu’il ait à se reconnecter.
    
    """
    pass


class HomeView(TemplateView):
    template_name = 'billetterie/home.html'


class CustomLoginView(View):
    template_name = 'billetterie/login.html'
   
    def post(self, request):
        email = request.POST.get('email')
        password = request.POST.get('password')

        if not email or not password:
            return render(request, self.template_name, {'error': 'Veuillez remplir tous les champs'})

        token_view = TokenObtainPairView.as_view()
        data = {'email': email, 'password': password}
        response = token_view(request, data=data)

        if response.status_code == status.HTTP_200_OK:
            utilisateur = get_user_model().objects.get(email=email)
            login(request, utilisateur)
            token_data = response.data
            request.session['access'] = token_data['access']
            request.session['refresh'] = token_data['refresh']

            next_url = request.GET.get('next')
            print(next_url)
            # Vérifie si l'URL est autorisée et sûre
            if next_url and url_has_allowed_host_and_scheme(next_url, allowed_hosts={request.get_host()}, require_https=request.is_secure()):
                return redirect(next_url)
            else:
                return redirect('billet')
        else:
            return render(request, self.template_name, {'error': 'Identifiants invalides'})
        

    def get(self, request):
        return render(request, self.template_name)
        

class LogoutView(LoginRequiredMixin, View):
    # template_name = 'billetterie/logout.html'
    def post(self, request, *args, **kwargs):
        logout(request)  # Déconnexion de l'utilisateur
        messages.success(request, 'Vous êtes maintenant déconnecté.')
        return redirect('home')  # Redirige vers la page d'accueil après la déconnexion
    
    def get(self, request, *args, **kwargs):
        return redirect('home')



class PanierView(ListView):
    model = Ticket
    template_name = 'billetterie/panier.html'
    context_object_name = 'tickets'

    def get_queryset(self):
        """Récupère les tickets et quantités du panier stocké dans la session utilisateur"""
        panier = self.request.session.get('panier', {})
        if panier:
            # Récupère les objets Ticket correspondant aux IDs dans le panier
            tickets_ids = panier.keys()
            tickets = Ticket.objects.filter(id__in=tickets_ids)
            # Attache les quantités aux tickets dans le queryset
            for ticket in tickets:
                ticket.quantite = panier.get(str(ticket.id), 1)  # Quantité par défaut à 1 si manquant
            return tickets
        return Ticket.objects.none()  # Si le panier est vide, retourne un queryset vide

    def get_context_data(self, **kwargs):
        """Ajoute le total du panier au contexte"""
        context = super().get_context_data(**kwargs)
        context['total_panier'] = self.calculer_total_panier()
        return context

    def post(self, request, *args, **kwargs):
        """Gère les ajouts, mises à jour et suppressions dans le panier"""
        ticket_id = request.POST.get('ticket_id')
        action = request.POST.get('action')
        quantite = int(request.POST.get('quantite', 1))

        if action == 'supprimer':
            self.supprimer_du_panier(ticket_id)
        else:
            self.ajouter_ou_mettre_a_jour_panier(ticket_id, quantite)

        return redirect('panier')  # Redirige vers la page du panier après l'ajout ou la suppression

    def ajouter_ou_mettre_a_jour_panier(self, ticket_id, quantite):
        """Ajoute ou met à jour un ticket dans le panier"""
        panier = self.request.session.get('panier', {})
        panier[str(ticket_id)] = panier.get(str(ticket_id), 0) + quantite
        self.request.session['panier'] = panier  # Met à jour le panier dans la session

    def supprimer_du_panier(self, ticket_id):
        """Supprime un ticket du panier"""
        panier = self.request.session.get('panier', {})
        if str(ticket_id) in panier:
            del panier[str(ticket_id)]
            self.request.session['panier'] = panier  # Met à jour la session

    def calculer_total_panier(self):
        """Calcule le total du panier en fonction des tickets et quantités"""
        total_panier = 0
        panier = self.request.session.get('panier', {})
        for ticket_id, quantite in panier.items():
            try:
                ticket = Ticket.objects.get(id=ticket_id)
                total_panier += ticket.price * quantite
            except Ticket.DoesNotExist:
                continue  # Ignore les tickets qui n'existent pas
        return total_panier


class AjouterAuPanierView(FormView):
    form_class = AjouterAuPanierForm
    template_name = 'billetterie/ajouter_au_panier.html'

    def form_valid(self, form):
        offer = get_object_or_404(Ticket, id=form.cleaned_data['offer_id'])
        quantity = form.cleaned_data['quantity']
        # Créer ou mettre à jour une transaction pour cet utilisateur
        transaction = Transaction.objects.create(
            user=self.request.user,
            offer=offer,
            quantity=quantity,
            total_price=offer.price * quantity,
            payment_status='PENDING'
        )
        # return redirect(reverse('afficher_panier')) # Redirection vers la page du panier après ajout
        return redirect('panier')



class ProfilView(LoginRequiredMixin, TemplateView):
    template_name = 'billetterie/profil.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        # Récupérer les transactions de l'utilisateur connecté
        transactions = Transaction.objects.filter(user=user, payment_status='COMPLETED').order_by('-transaction_date')
        context['transactions'] = transactions
        return context
    


class BilletView(LoginRequiredMixin, ListView):
    model = Ticket
    template_name = 'billetterie/reserver-billet.html'
    context_object_name = 'tickets' # Le nom du contexte pour accéder aux tickets dans le template
    login_url = 'login' # Rediriger vers cette URL si l'utilisateur n'est pas connecté
    redirect_field_name = 'next' # Paramètre GET pour stocker l'URL de redirection
    
    def get_queryset(self):
        # Personnalisation du queryset (par ex. filtrer ou ordonner)
        return Ticket.objects.all().order_by('price')
    
    def post(self, request, *args, **kwargs):
        # Récupération de l'ID du ticket depuis la requete POST
        ticket_id = request.POST.get('ticket_id')
        if not ticket_id:
            messages.error(request, "Aucun billet sélectionné.")
            return redirect('billet')
        
        ticket = get_object_or_404(Ticket, id=ticket_id)

        # Ajout du ticket au panier de l'utilisateur
        panier = request.session.get('panier', {})

        # Vérifie si le panier est bien un dictionnaire
        if not isinstance(panier, dict):
            panier = {}
        
        # Ajout du ticket au panier avec une quantité de 1 si pas encore dans le panier
        if str(ticket.id) in panier:    
            messages.info(request, f"{ticket.nom} est déjà dans votre panier.")
        else:
            panier[str(ticket.id)] = 1 # Par défaut, quantité=1 pur un nouvel ajout
            request.session['panier'] = panier
            messages.success(request, f"{ticket.nom} a été ajouté au panier.")

        # Redirige vers le panier ou une autre page après l'ajout
        return redirect('panier')
    
    def get(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            messages.info(request, "Veuillez vous connecter pour accéder à cette page.")

            # récupération de l'URL de redirection
            redirect_url = f'{self.login_url}?next={request.path}'
            # Vérification de l'URL de redirection avec url_has_allowed_host_and_scheme
            if url_has_allowed_host_and_scheme(redirect_url, allowed_hosts={request.get_host()}):
                return redirect(redirect_url)
            else:
                messages.error(request, "Redirection non autorisée.")
                return redirect('login')  # Rediriger vers la page de connexion de manière sécurisée
            return redirect(f'{self.login_url}?next={request.path}')
        
        # Si l'utilisateur est connecté, procéder normalement
        return super().get(request, *args, **kwargs)
    


class CheckoutView(FormView):
    template_name = 'billetterie/checkout.html'
    form_class = CheckoutForm

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Récupérer le panier depuis la session
        panier = self.request.session.get('panier', {})
        tickets = Ticket.objects.filter(id__in=panier.keys())
        # Calculer le total du panier
        total_panier = sum(ticket.price * panier[str(ticket.id)] for ticket in tickets)
        context['tickets'] = tickets
        context['total_panier'] = total_panier
        return context

    def form_valid(self, form):
        # Vérifie que les CGV sont acceptées
        if not form.cleaned_data['accept_cgv']:
            form.add_error('accept_cgv', "Vous devez accepter les Conditions Générales de Vente.")
            return self.form_invalid(form)

        # Enregistre les informations du formulaire dans la session
        self.request.session['adresse'] = form.cleaned_data['adresse']
        self.request.session['telephone'] = form.cleaned_data['telephone']

        # Redirige vers la page de confirmation où le formulaire caché sera soumis via POST
        return super().form_valid(form)
    
    def get_success_url(self):
        # Retourner l'URL de la vue de paiement
        return reverse('checkout')

    

class PaymentView(View):
    def post(self, request, *args, **kwargs):
        stripe.api_key = settings.STRIPE_SECRET_KEY

        user = request.user
        panier = request.session.get('panier', {})
        adresse = request.session.get('adresse')
        telephone = request.session.get('telephone')

        if not panier:
            return HttpResponse("Votre panier est vide", status=400)
        
        tickets = Ticket.objects.filter(id__in=panier.keys())
        line_items = []
        total_price = 0

        # Configurer les articles Stripe pour le paiement
        for ticket in tickets:
            quantity = panier[str(ticket.id)]
            total_price += ticket.price * quantity
            line_items.append({
                'price_data': {
                    'currency': 'eur',
                    'product_data': {
                        'name': ticket.get_name_display(),
                    },
                    'unit_amount': int(ticket.price * 100),  # En centimes
                },
                'quantity': quantity,  # Quantité pour chaque ticket
            })

        try:
            # Création de la session de paiement Stripe
            checkout_session = stripe.checkout.Session.create(
                payment_method_types=['card'],
                line_items=line_items,
                mode='payment',
                customer_email=user.email if user.is_authenticated else None,
                success_url=request.build_absolute_uri(reverse('payment_success')) + '?session_id={CHECKOUT_SESSION_ID}',
                cancel_url=request.build_absolute_uri(reverse('payment_cancel')) + '?session_id={CHECKOUT_SESSION_ID}',
                metadata={
                    'session_id': 'session_id_placeholder'  # Utilise un placeholder temporaire
                }
            )
            # Remplace le placeholder par l'ID réel de la session Stripe une fois que la session est créée
            stripe.checkout.Session.modify(
                checkout_session.id,
                metadata={
                    'session_id': checkout_session.id  # Remplace par l'ID réel de la session
                }
            )
        
            # Enregistrer la transaction avec le total calculé dans la vue
            transaction = Transaction.objects.create(
                user=user,
                quantity=sum(panier.values()),  # Quantité totale dans le panier
                total_price=total_price,  # Prix total calculé ici dans la vue
                payment_status='PENDING',
                payment_method='Carte de crédit (fictive)',
                transaction_id=checkout_session.id  # ID de la session Stripe
            )

            # Ajouter les tickets à la relation ManyToMany
            transaction.offer.set(tickets)

            # Redirection vers Stripe
            return redirect(checkout_session.url, code=303)
    
        except stripe.error.StripeError as e:
            logger.error(f"Erreur Stripe lors du paiement : {str(e)}")
            return HttpResponse("Une erreur est survenue lors du traitement du paiement. Veuillez réessayer plus tard.", status=500)
        
    def get(self, request, *args, **kwargs):
        return HttpResponse("Accès à la page de paiement uniquement via POST.", status=405)



class PaymentSuccessView(View):
    def get(self, request, *args, **kwargs):
        # Récupérer l'ID de la session Stripe pour retrouver la transaction
        session_id = request.GET.get('session_id')  # Utilise 'session_id'
        
        if not session_id:
            return HttpResponse("Stripe ID manquant", status=400)
        
        try:
            # Utiliser transaction_id pour retrouver la transaction
            transaction = Transaction.objects.get(transaction_id=session_id)
            utilisateur = transaction.user # Récupérer l'utilisateur lié à la transaction
        except Transaction.DoesNotExist:
            return HttpResponse("Aucune transaction ne correspond à cet ID", status=404)

        # Ne pas mettre à jour le statut ici, cela est géré par le webhook

        # Générer le jeton JWT et le QR code
        jwt_token = self.generate_jwt(transaction.confirmation_code, utilisateur.unique_key)
        qr_code_image = self.generate_qr_code(jwt_token)

        # Envoyer l'email avec le billet
        self.send_ticket_email(utilisateur, transaction, jwt_token, qr_code_image)
        

        # Réinitialiser le panier uniquement si la transaction est bien complétée
        if transaction.payment_status == 'COMPLETED' and 'panier' in request.session:
            del request.session['panier']

        # Rendre le template de succès
        return render(request, 'billetterie/payment_success.html', {'transaction': transaction})
    

    # Méthodes pour QRcode et JWT
    def generate_jwt(self, confirmation_code, unique_key):
        # Crée un jeton JWT avec une durée de validité (ex. 1 jour)
        payload = {
            'confirmation_code': confirmation_code,
            'unique_key': unique_key,
            'exp': datetime.now() + timedelta(days=1),  # Expiration dans 1 jour
            'iat': datetime.now()  # Date de génération
        }

        # Crée le jeton JWT
        token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')
        return token

    def generate_qr_code(self, data):
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(data)
        qr.make(fit=True)

        # Crée l'image du QR code
        img = qr.make_image(fill='black', back_color='white')

        # Convertir l'image en mémoire pour l'attacher à un email
        buffer = BytesIO()
        img.save(buffer, format="PNG")
        buffer.seek(0)
        
        return buffer


    # Envoi de l'email avec le billet
    def send_ticket_email(self, utilisateur, transaction, jwt_token, qr_code_image):
        subject = 'Votre billet pour l\'événement - JO Paris 2024'
        body = render_to_string('billetterie/ticket_email.html', {
            'user': utilisateur,
            'confirmation_code': transaction.confirmation_code,
            'unique_key': utilisateur.unique_key,
            'jwt_token': jwt_token
        })
        
        # Crée l'email avec l'image du QR code en pièce jointe
        email = EmailMessage(subject, body, to=[utilisateur.email])
        email.attach('ticket_qr_code.png', qr_code_image.getvalue(), 'image/png')
        email.content_subtype = 'html'  # Envoyer le mail en HTML
        email.send()


        


    

class PaymentCancelView(View):
    template_name = 'billetterie/payment_cancel.html'

    def get(self, request, *args, **kwargs):
        # Récupérer l'ID de la session Stripe pour identifier la transaction échouée
        session_id = request.GET.get('session_id')  # Utilise 'session_id'
        transaction = None
        
        if session_id:
            try:
                # Utiliser transaction_id pour retrouver la transaction
                transaction = Transaction.objects.get(transaction_id=session_id)
                # Ne pas mettre à jour le statut ici, cela est géré par le webhook
            except Transaction.DoesNotExist:
                transaction = None  # Si la transaction n'existe pas, reste sur None

        context = {
            'transaction': transaction
        }

        # Si transaction est None, ajouter un message d'erreur pour le template
        if not transaction:
            context['error'] = "Transaction non trouvée ou déjà échouée."

        return render(request, self.template_name, context)




logger = logging.getLogger(__name__)

@method_decorator(csrf_exempt, name='dispatch')
class StripeWebhookView(View):

    def post(self, request, *args, **kwargs):
        print("Entrée dans la vue StripeWebhookView")
        endpoint_secret = settings.STRIPE_WEBHOOK_SECRET
        payload = request.body
        sig_header = request.META.get('HTTP_STRIPE_SIGNATURE')
        event = None

        try:
            event = stripe.Webhook.construct_event(payload, sig_header, endpoint_secret)
            print(f"Webhook reçu : {event['type']}")
        except ValueError as e:
            print(f"Payload invalide reçu : {e}")
            return HttpResponse("Données du webhook invalides.", status=400)
        except stripe.error.SignatureVerificationError as e:
            print(f"Signature du webhook non valide : {e}")
            return HttpResponse("Signature du webhook non valide.", status=400)

        # Gérer l'événement checkout.session.completed
        if event['type'] == 'checkout.session.completed':
            print(f"Session de paiement complétée : {event['data']['object']['id']}")
            session = event['data']['object']
            session_id = session.get('id')

            try:
                # Mettre à jour la transaction dans la base de données
                transaction = Transaction.objects.get(transaction_id=session_id)
                transaction.payment_status = 'COMPLETED'  # Met à jour le statut comme payé
                transaction.payment_intent = session.get('payment_intent')  # Récupère l'ID du Payment Intent
                confirmation_code = self.generate_unique_confirmation_code()
                transaction.confirmation_code = confirmation_code
                transaction.save()
                print(f"Transaction complétée : {transaction}")
            except Transaction.DoesNotExist:
                return HttpResponse("Transaction non trouvée.", status=404)

        # Gérer l'événement payment_intent.payment_failed
        elif event['type'] == 'payment_intent.payment_failed':
            print(f"Échec du paiement pour le Payment Intent : {event['data']['object']['id']}")
            intent = event['data']['object']
            payment_intent_id = intent.get('id')
            print(payment_intent_id)

            # Récupérer le session_id depuis les metadata
            metadata = intent.get('metadata')
            session_id = metadata.get('session_id') if metadata else None
            print(f"Metadata récupérées : {metadata}")
            print(f"Session ID : {session_id}")

            if session_id:
                try:
                    # Récupérer la transaction en utilisant l'ID de session
                    transaction = Transaction.objects.get(transaction_id=session_id)
                    transaction.payment_intent = payment_intent_id
                    transaction.payment_status = 'FAILED'
                    transaction.save()
                    print(f"Transaction échouée mise à jour : {transaction}")
                except Transaction.DoesNotExist:
                    return HttpResponse("Transaction non trouvée.", status=404)
            else:
                return HttpResponse("Session ID non trouvé dans les metadata.", status=400)

        return JsonResponse({'status': 'success'}, status=200)


    def generate_confirmation_code(self):
        """Génère un code de confirmation unique"""
        return get_random_string(10).upper()

    def generate_unique_confirmation_code(self):
        """Génère un code unique et vérifie qu'il n'existe pas déjà"""
        while True:
            code = self.generate_confirmation_code()
            if not Transaction.objects.filter(confirmation_code=code).exists():
                return code
            

            



# QRcode et JWT

def generate_jwt(confirmation_code, unique_key):
    # Crée un jeton JWT avec une durée de validité (ex. 1 jour)
    payload = {
        'confirmation_code': confirmation_code,
        'unique_key': unique_key,
        'exp': datetime.utcnow() + timedelta(days=1),  # Expiration dans 1 jour
        'iat': datetime.utcnow()  # Date de génération
    }

    # Crée le jeton JWT
    token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')
    return token


def generate_qr_code(data):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    # Crée l'image du QR code
    img = qr.make_image(fill='black', back_color='white')

    # Convertir l'image en mémoire pour l'attacher à un email
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)
    
    return buffer
