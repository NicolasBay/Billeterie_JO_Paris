from django.contrib import admin

# Register your models here.
from .models import Ticket
from .models import Utilisateur
from .models import Transaction
admin.site.register(Ticket)
# admin.site.register(Utilisateur)
admin.site.register(Transaction)


# Créer un affichage personnalisé pour les utilisateurs
# Si Utilisateur est déjà enregistré, on le réenregistre avec la nouvelle configuration
class UtilisateurAdmin(admin.ModelAdmin):
    list_display = ('email', 'first_name', 'last_name', 'nombre_de_ventes')
    search_fields = ('email', 'first_name', 'last_name')

    # Méthode pour afficher le nombre de ventes (transactions complétées)
    def nombre_de_ventes(self, obj):
        # Compter les transactions dont le statut est "COMPLETED" pour chaque utilisateur
        return Transaction.objects.filter(user=obj, payment_status='COMPLETED').count()

    # Définir un en-tête personnalisé pour la colonne
    nombre_de_ventes.short_description = 'Nombre de ventes'

# Enregistrer le modèle Utilisateur avec sa configuration personnalisée
admin.site.register(Utilisateur, UtilisateurAdmin)  # Réenregistre avec la nouvelle configuration