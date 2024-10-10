from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import login, get_user_model, logout
from django.contrib.auth.views import LoginView
from django.contrib.auth.mixins import LoginRequiredMixin # garantit que la vue est protégée par la vérification de l'authentification
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.urls import reverse_lazy
from django.views import View
from django.views.generic import TemplateView, ListView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.response import Response
from rest_framework import status
from .forms import SignupForm
from .models import Ticket
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
    context_object_name = 'tickets' # Nom utilisé pour accéder aux objets dans le template

    def get_queryset(self):
        # Récupère les tickets dans le panier stocké dans la session utilisateur
        panier = self.request.session.get('panier', [])
        if panier:
            return Ticket.objects.filter(id__in=panier)
        return Ticket.objects.none() # Si le panier est vide, retourne un queryset vide
    
    def post(self, request, *args, **kwargs):
        # Récupération de l'id du ticket à ajouter au panier
        ticket_id = request.POST.get('ticket_id')
        if not ticket_id:
            return redirect('panier') # redirection si l'id est absent
        
        # Vérifie si le ticket existe dans la base de données
        ticket = get_object_or_404(Ticket, id=ticket_id)

        # Récupère ou initialise  le panier dans la session
        panier = request.session.get('panier', [])
        if ticket.id not in panier:
            panier.append(ticket.id)
            request.session['panier'] = panier # Met à jour le panier dans la session

        return redirect('panier') # Redirige vers la page du panier après l'ajout



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
        panier = request.session.get('panier', [])
        if ticket.id not in panier:    
            panier.append(ticket.id)
            request.session['panier'] = panier
            messages.success(request, f"{ticket.nom} a été ajouté au panier.")
        else:
            messages.info(request, f"{ticket.nom} est déjà dans votre panier.")

        # Redirige vers le panier ou une autre page après l'ajout
        return redirect('panier', ticket_id=ticket.id)
    
    def get(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            messages.info(request, "Veuillez vous connecter pour accéder à cette page.")
            return redirect(f'{self.login_url}?next={request.path}')
        return super().get(request, *args, **kwargs)
    
