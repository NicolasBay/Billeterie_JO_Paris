from typing import Iterable
from django.db import models
from django.conf import settings
from django.utils import timezone
from django.contrib.auth.models import AbstractUser, BaseUserManager # AbstractUser = classe par défaut pour gérer les utilisateurs
from django.utils.crypto import get_random_string # pour générer des chaînes de caractères aléatoires


# Gestionnaire d'Utilisateur Personnalisé

class UtilisateurManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("L'email doit etre renseigné.")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Le superutilisateur doit avoir is_staff=True')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError ('Le superutilisateur doit avoir is_superuser=True')
        
        return self.create_user(email, password, **extra_fields)
    

# Modèle utilisateur personnalisé

class Utilisateur(AbstractUser):
    objects = UtilisateurManager()
    unique_key = models.CharField(max_length=32, unique=True, editable=False)
    username = None
    email = models.EmailField(unique=True)
    USERNAME_FIELD = 'email' # Dénitit l'email comme champ principal pour l'authentification
    REQUIRED_FIELDS = [] # ne mets pas 'email' dans les champs requis supplémentaires
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
    offer = models.ManyToManyField(Ticket)
    quantity = models.PositiveIntegerField(default=1)
    total_price = models.DecimalField(max_digits=8, decimal_places=2, default=0.00)
    transaction_date = models.DateTimeField(default=timezone.now)
    payment_status = models.CharField(max_length=10, choices=PAYMENT_STATUS_CHOICES, default='PENDING')
    payment_method = models.CharField(max_length=50)
    transaction_id = models.CharField(max_length=100, unique=True) # ID de la session Stripe (unique pour chaque transaction)
    payment_intent = models.CharField(max_length=100, blank=True, null=True) # ID du Payment Intent Stripe
    confirmation_code = models.CharField(max_length=20, blank=True, null=True, unique=True) # Code de confirmation généré après la réussite du paiement
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Transaction {self.transaction_id} - {self.user.email} - {self.total_price} €"
    
    def generate_confirmation_code(self):
        # Génère un code de confirmation unique
        return get_random_string(10).upper()
    
    def save(self, *args, **kwargs):
        # Générer un code de confirmation unique si le paiement est complété
        if self.payment_status == 'COMPLETED' and not self.confirmation_code:
            self.generate_confirmation_code = self.generate_unique_confirmation_code()
        
        super().save(*args, **kwargs)

    def generate_unique_confirmation_code(self):
        # Génère un code de confirmation unique en vérifiant qu'il n'existe pas déjà en base de données
        while True:
            code = self.generate_confirmation_code()
            if not Transaction.objects.filter(confirmation_code=code).exists():
                return code

    