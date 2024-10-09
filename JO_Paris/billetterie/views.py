from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth.views import LoginView
from django.contrib.auth.mixins import LoginRequiredMixin
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
            token_data = response.data
            request.session['access'] = token_data['access']
            request.session['refresh'] = token_data['refresh']
            messages.success(request, 'Vous êtes maintenant connecté.')
            # return redirect(request.GET.get('next') or 'home')
            return redirect('billet')
        else:
            return render(request, self.template_name, {'error': 'Identifiants invalides'})
        
    def get(self, request):
        # vérifie si l'utilisateur a été redirigé avec un paramère 'next'
        # next_url = request.GET.get('next')
        # if next_url:
        # messages.info(request, "Pour réserver un billet, merci de vous connecter.")
        # print("Redirection vers la page de connexion avec next =", next_url) # Message de debogage
        return render(request, self.template_name)
        
     
class PanierView(View):
    template_name = 'billetterie/panier.html'
    def get(self, request, ticket_id):
        # Ici, je peux récupérer les données du panier (par exemple, depuis la session ou la base de données)
        ticket = get_object_or_404(Ticket, id=ticket_id)
        # Pour l'instant, je retourne simplement le template
        return render(request, self.template_name, {'ticket': ticket})


class ProfilView(LoginRequiredMixin, View):
    template_name = 'billetterie/profil.html'
    def get(self, request):
        # Ici, je peux récupérer les données du profil (par exemple, depuis la session ou la base de données)
        user = request.user
        return render(request, self.template_name, {'user':user})
    

# @method_decorator(login_required, name='dispatch')
class BilletView(ListView):
    model = Ticket
    template_name = 'billetterie/reserver-billet.html'
    context_object_name = 'tickets' # Le nom du contexte pour accéder aux tickets dans le template
    
    def get_queryset(self):
        # Personnalisation du queryset (par ex. filtrer ou ordonner)
        return Ticket.objects.all().order_by('price')
    
    
    def post(self, request, *args, **kwargs):
        # Vérifie si l'utilisateur est connecté
        if not request.user.is_authenticated:
            messages.warning(request, "Vous devez être connecté pour réserver un billet.")
            return redirect('login') # Redirige vers la page de connexion


        # Récupération de l'ID du ticket depuis la requete POST
        ticket_id = request.POST.get('ticket_id')
        if not ticket_id:
            return redirect('billet')
        
        ticket = get_object_or_404(Ticket, id=ticket_id)

        # Ajout du ticket au panier de l'utilisateur
        panier = request.session.get('panier', [])
        panier.append(ticket.id)
        request.session['panier'] = panier

        # Redirige vers le panier ou une autre page après l'ajout
        return redirect('panier', ticket_id=ticket.id)
    
    def get(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            print("Utilisateur authentifié : ", request.user.email)  # Message de débogage
        else:
            print("Utilisateur non authentifié")
        return super().get(request, *args, **kwargs)
    
    def billet_view(request):
        print(f"User authenticated: {request.user.is_authenticated}")