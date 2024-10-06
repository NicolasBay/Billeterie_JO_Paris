from django.urls import path
from .views import SignupView, CustomTokenObtainPairView, CustomTokenRefreshView


urlpatterns = [
    path('signup/', SignupView.as_view(), name='signup'), # vue basée sur une fonction
    path('login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'), # vue basée sur une classe
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
]