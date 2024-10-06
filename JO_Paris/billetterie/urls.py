from django.urls import path
from .views import SignupView, CustomTokenObtainPairView, CustomTokenRefreshView
from .views import HomeView, CustomLoginView


urlpatterns = [
    path('', HomeView.as_view(), name='home'),
    path('signup/', SignupView.as_view(), name='signup'), 
    path('login/', CustomLoginView.as_view(), name='login'), 
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
]