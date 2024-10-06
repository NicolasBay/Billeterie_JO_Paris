from django.urls import path
from .views import SignupView, CustomTokenObtainPairView, CustomTokenRefreshView
from .views import HomeView, CustomLoginView, PanierView, ProfilView


urlpatterns = [
    path('', HomeView.as_view(), name='home'),
    path('signup/', SignupView.as_view(), name='signup'), 
    path('login/', CustomLoginView.as_view(), name='login'), 
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('panier/', PanierView.as_view(), name='panier'),
    path('profil/', ProfilView.as_view(), name='profil'),
]