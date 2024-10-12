from django import forms
from .models import Utilisateur 
from django.core.exceptions import ValidationError

class SignupForm(forms.ModelForm):
    password1 = forms.CharField(label="Mot de passe", widget=forms.PasswordInput(attrs={'placeholder': 'Mot de passe'}), required=True)
    password2 = forms.CharField(label="Confirmer mot de passe", widget=forms.PasswordInput(attrs={'placeholder': 'Confirmez le mot de passe'}), required=True)

    class Meta:
        model = Utilisateur  # Utiliser le modèle Utilisateur
        fields = ['email', 'email', 'first_name', 'last_name']  # Inclure les champs requis

    def clean_username(self):
        email = self.cleaned_data['email']
        if Utilisateur.objects.filter(email=email).exists():
            raise ValidationError("Un utilisateur avec ce nom d'utilisateur existe déjà.")
        return email

    def clean_email(self):
        email = self.cleaned_data['email']
        if Utilisateur.objects.filter(email=email).exists():
            raise ValidationError("Un utilisateur avec cet email existe déjà.")
        return email

    def clean(self):
        cleaned_data = super().clean()
        password1 = cleaned_data.get('password1')
        password2 = cleaned_data.get('password2')

        if password1 and password2 and password1 != password2:
            raise ValidationError("Les mots de passe ne correspondent pas.")
        return cleaned_data

    def save(self, commit=True):
        utilisateur = super().save(commit=False)  # Créer l'utilisateur sans l'enregistrer
        utilisateur.set_password(self.cleaned_data['password1'])  # Définit le mot de passe
        if commit:
            utilisateur.save()  # Enregistrer dans la base de données
        return utilisateur
    

class AjouterAuPanierForm(forms.Form):
    offer_id = forms.IntegerField(widget=forms.HiddenInput())
    quantity = forms.IntegerField(min_value=1, initial=1)


class CheckoutForm(forms.Form):
    address = forms.CharField(label="Adresse", max_length=255, widget=forms.TextInput(attrs={'class': 'form-control'}))
    phone_number = forms.CharField(label="Numéro de téléphone", max_length=15, widget=forms.TextInput(attrs={'class': 'form-control'}))
    accept_cgv = forms.BooleanField(label="J'accepte les Conditions Générales de Vente", required=True)



