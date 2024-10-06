from django.shortcuts import render, redirect
from django.contrib.auth import login
from .forms import SignupForm
from  django.views import View
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView


class SignupView(View):
    def get(self, request):
        form = SignupForm()
        return render(request, 'signup.html', {'form': form})

    def post(self, request):
        form = SignupForm(request.POST)
        if form.is_valid():
            utilisateur = form.save()
            login(request, utilisateur)
            return redirect('home')
        return render(request, 'signup.html', {'form': form})

    

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



