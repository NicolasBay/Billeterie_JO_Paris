from django.db import models
from django.contrib.auth.models import AbstractUser # AbstractUser = classe par défaut pour gérer les utilisateurs
from django.utils.crypto import get_random_string # pour générer des chaînes de caractères aléatoires


# Modèle utilisateur personnalisé

class Utilisateur(AbstractUser):
    unique_key = models.CharField(max_length=32, unique=True, editable=False)
    """
    En héritant de AbstractUser, tu obtiens déjà les champs standards (comme username, password, etc.) 
    sans avoir besoin de redéfinir ces champs dans ton modèle.
    """
    def save(self, *args, **kwargs): # Méthode appelée lorsque l'objet est sauvegardé dans la base de données.
        if not self.unique_key: # Vérifie si unique_key n’a pas encore été défini
            self.unique_key = get_random_string(length=32) #  Si unique_key n’est pas défini, génère une chaîne aléatoire de 32 caractères et l’assigne à unique_key
        super().save(*args, **kwargs) # Appelle la méthode save de la classe parente (AbstractUser), ce qui effectue la sauvegarde réelle de l’objet dans la base de données.

    def __str__(self): # Cette méthode définit la représentation en chaîne de caractères de l’objet.    
        return self.email # Ici, elle retourne l’adresse email de l’utilisateur, utile pour l’affichage dans l’interface d’administration de Django

    