from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login
from django.contrib.auth.views import LoginView
from django.contrib.auth.mixins import LoginRequiredMixin
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
    def get(self, request):
        return render(request, self.template_name)
    
    def post(self, request):
        username = request.POST.get('username')
        password = request.POST.get('password')

        if not username or not password:
            return render(request, self.template_name, {'error': 'Veuillez remplir tous les champs'})

        token_view = TokenObtainPairView.as_view()
        data = {'username': username, 'password': password}
        response = token_view(request._request, data=data)

        if response.status_code == status.HTTP_200_OK:
            token_data = response.data
            request.session['access'] = token_data['access']
            request.session['refresh'] = token_data['refresh']
            return redirect('home')
        else:
            return render(request, self.template_name, {'error': 'Identifiants invalides'})
        
        
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
    

class BilletView(ListView):
    model = Ticket
    template_name = 'billetterie/reserver-billet.html'
    context_object_name = 'tickets' # Le nom du contexte pour accéder aux tickets dans le template
    
    def get_queryset(self):
        # Si tu veux personnaliser le queryset (par ex. filtrer ou ordonner), tu peux le faire ici
        return Ticket.objects.all().order_by('price')  # Exemple d'ordre par prix

