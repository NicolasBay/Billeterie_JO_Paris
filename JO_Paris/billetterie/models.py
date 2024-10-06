from django.db import models
from django.contrib.auth.models import AbstractUser # AbstractUser = classe par défaut pour gérer les utilisateurs
from django.utils.crypto import get_random_string # pour générer des chaînes de caractères aléatoires


# Modèle utilisateur personnalisé

class Utilisateur(AbstractUser):
    unique_key = models.CharField(max_length=32, unique=True, editable=False)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=128)

    def save(self, *args, **kwargs):
        # Génération d'une clé unique si elle n'existe pas encore
        if not self.unique_key:
            self.unique_key = get_random_string(length=32)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.email

    