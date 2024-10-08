from typing import Iterable
from django.db import models
from django.conf import settings
from django.utils import timezone
from django.contrib.auth.models import AbstractUser # AbstractUser = classe par défaut pour gérer les utilisateurs
from django.utils.crypto import get_random_string # pour générer des chaînes de caractères aléatoires


# Modèle utilisateur personnalisé

class Utilisateur(AbstractUser):
    unique_key = models.CharField(max_length=32, unique=True, editable=False)
    """
    En héritant de AbstractUser, j'obtiens déjà les champs standards (comme username, password, etc.) 
    sans avoir besoin de redéfinir ces champs dans le modèle.
    """
    def save(self, *args, **kwargs): # Méthode appelée lorsque l'objet est sauvegardé dans la base de données.
        if not self.unique_key: # Vérifie si unique_key n’a pas encore été défini
            self.unique_key = get_random_string(length=32) #  Si unique_key n’est pas défini, génère une chaîne aléatoire de 32 caractères et l’assigne à unique_key
        super().save(*args, **kwargs) # Appelle la méthode save de la classe parente (AbstractUser), ce qui effectue la sauvegarde réelle de l’objet dans la base de données.

    def __str__(self): # Cette méthode définit la représentation en chaîne de caractères de l’objet.    
        return self.email # Ici, elle retourne l’adresse email de l’utilisateur, utile pour l’affichage dans l’interface d’administration de Django
    


# Modèle des offres de tickets

class Ticket(models.Model):
    OFFER_CHOICES = [
        ('SOLO', 'Offre Solo'),
        ('DUO', 'Offre Duo'),
        ('FAMILLE', 'Offre Famille'),
    ]

    name = models.CharField(max_length=50, choices=OFFER_CHOICES, unique=True)
    description = models.TextField()
    price = models.DecimalField(max_digits=6, decimal_places=2)
    nb_person = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.get_name_display()} - {self.price}"



# Modèle des transactions

class Transaction(models.Model):
    PAYMENT_STATUS_CHOICES = [
        ('PENDING', 'En attente'),
        ('COMPLETED', 'Complété'),
        ('FAILED', 'Echoué'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    offer = models.ForeignKey('Ticket', on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField
    total_price = models.DecimalField(max_digits=8, decimal_places=2)
    transaction_date = models.DateTimeField(default=timezone.now)
    payment_status = models.CharField(max_length=10, choices=PAYMENT_STATUS_CHOICES, default='PENDING')
    payment_method = models.CharField(max_length=50)
    transaction_id = models.CharField(max_length=100, unique=True, default=get_random_string)
    confirmation_code = models.CharField(max_length=20, blank=True, null=True, unique=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Transaction {self.transaction_id - self.user - self.total_price} €"
    
    def generate_confirmation_code(self):
        # Génère un code de confirmation unique
        return get_random_string(10).upper()
    
    def save(self, *args, **kwargs):
        # Surcharge de la méthode save pour s'assurer que le code de confirmation est unique et généré si le paiement est complété.
        if self.payment_status == 'COMPLETED' and not self.confirmation_code:
            self.generate_confirmation_code = self.generate_unique_confirmation_code()
        super().save(*args, **kwargs)

    def generate_unique_confirmation_code(self):
        # Génère un code de confirmation unique en vérifiant qu'il n'existe pas déjà en base de données
        while True:
            code = self.generate_confirmation_code()
            if not Transaction.objects.filter(confirmation_code=code).exists ():
                return code

    