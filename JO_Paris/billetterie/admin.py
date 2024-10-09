from django.contrib import admin

# Register your models here.
from .models import Ticket
from .models import Utilisateur
admin.site.register(Ticket)
admin.site.register(Utilisateur)