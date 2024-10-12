from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import login, get_user_model, logout
from django.contrib.auth.views import LoginView
from django.contrib.auth.mixins import LoginRequiredMixin # garantit que la vue est protégée par la vérification de l'authentification
from django.contrib.auth.decorators import login_required
import stripe
from django.conf import settings
from django.utils.decorators import method_decorator
from django.utils.http import url_has_allowed_host_and_scheme
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse_lazy, reverse
from django.views import View
from django.views.generic import TemplateView, ListView, FormView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.response import Response
from rest_framework import status
from .forms import SignupForm, AjouterAuPanierForm, CheckoutForm
from .models import Ticket, Transaction
import os



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
            # messages.success(request, 'Vous êtes maintenant connecté.')

            next_url = request.GET.get('next')
            if next_url:
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
        if not ticket_id:
            return redirect('panier')  # Redirection si l'id est absent

        action = request.POST.get('action')
        if action == 'supprimer':
            self.supprimer_du_panier(ticket_id)
        else:
            quantite = int(request.POST.get('quantite', 1))  # Quantité par défaut à 1
            self.ajouter_ou_mettre_a_jour_panier(ticket_id, quantite)

        return redirect('panier')  # Redirige vers la page du panier après l'ajout ou la suppression

    def ajouter_ou_mettre_a_jour_panier(self, ticket_id, quantite):
        """Ajoute ou met à jour un ticket dans le panier"""
        panier = self.request.session.get('panier', {})
        if str(ticket_id) in panier:
            panier[str(ticket_id)] += quantite  # Incrémente la quantité si déjà présent
        else:
            panier[str(ticket_id)] = quantite  # Ajoute le ticket avec la quantité
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
        return redirect(reverse('afficher_panier')) # Redirection vers la page du panier après ajout



class ProfilView(LoginRequiredMixin, View):
    template_name = 'billetterie/profil.html'
    def get(self, request):
        # Ici, je peux récupérer les données du profil (par exemple, depuis la session ou la base de données)
        user = request.user
        return render(request, self.template_name, {'user':user})
    


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

        # Enregistrer l'adresse, le téléphone, etc. et rediriger vers l'API de paiement
        return redirect(self.get_success_url())

    def get_success_url(self):
        # Rediriger vers l'API de paiement (par exemple, Stripe ou PayPal)
        # Vous pouvez rediriger ici vers une URL personnalisée pour l'API tierce
        return reverse('payment')  # Rediriger vers la vue de paiement



class PaymentView(View):
    def get(self, request, *args, **kwargs):
        # Utilisation de Stripe ici
        stripe.api_key = settings.STRIPE_SECRET_KEY

        panier = request.session.get('panier', {})
        tickets = Ticket.objects.filter(id__in=panier.keys())
        line_items = []

        # Boucle sur les articles dans le panier pour configurer les éléments Stripe
        for ticket in tickets:
            line_items.append({
                'price_data': {
                    'currency': 'eur',
                    'product_data': {
                        'name': ticket.get_name_display(),
                    },
                    'unit_amount': int(ticket.price * 100),  # En centimes
                },
                'quantity': panier[str(ticket.id)],
            })

        # Création de la session de paiement Stripe
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=line_items,
            mode='payment',
            success_url=request.build_absolute_uri(reverse('payment_success')),
            cancel_url=request.build_absolute_uri(reverse('payment_cancel')),
        )

        # Redirection vers Stripe
        return redirect(checkout_session.url, code=303)