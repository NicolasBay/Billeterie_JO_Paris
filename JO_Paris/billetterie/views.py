from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib.auth.views import LoginView
from django.urls import reverse_lazy
from .forms import SignupForm
from django.views import View
from django.views.generic import TemplateView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.response import Response
from rest_framework import status
import os


class SignupView(View):
    def get(self, request):
        form = SignupForm()
        return render(request, 'billetterie/signup.html', {'form': form})

    def post(self, request):
        form = SignupForm(request.POST)
        if form.is_valid():
            utilisateur = form.save()
            login(request, utilisateur)
            return redirect('home')
        return render(request, 'billetterie/signup.html', {'form': form})

    

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
        

        

