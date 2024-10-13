from django import forms
from .models import Utilisateur 
from django.core.exceptions import ValidationError
from django.contrib.auth import password_validation


class SignupForm(forms.ModelForm):
    password1 = forms.CharField(
        label="Mot de passe",
        widget=forms.PasswordInput(attrs={'placeholder': 'Mot de passe'}),
        required=True,
        help_text=password_validation.password_validators_help_text_html()  # Ajoute un texte d'aide expliquant les règles
        )
    password2 = forms.CharField(
        label="Confirmer mot de passe",
        widget=forms.PasswordInput(attrs={'placeholder': 'Confirmez le mot de passe'}),
        required=True
        )

    class Meta:
        model = Utilisateur  # Utiliser le modèle Utilisateur
        fields = ['email', 'first_name', 'last_name']  # Inclure les champs requis

    # def clean_username(self):
    #     email = self.cleaned_data['email']
    #     if Utilisateur.objects.filter(email=email).exists():
    #         raise ValidationError("Un utilisateur avec ce nom d'utilisateur existe déjà.")
    #     return email

    def clean_email(self):
        email = self.cleaned_data['email']
        if Utilisateur.objects.filter(email=email).exists():
            raise ValidationError("Un utilisateur avec cet email existe déjà.")
        return email
    
    def clean_password1(self):
        password1 = self.cleaned_data.get('password1')
        # Appliquer les validateurs de mot de passe de Django
        try:
            password_validation.validate_password(password1)
        except ValidationError as e:
            raise ValidationError(e)
        return password1

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
    adresse = forms.CharField(max_length=255, required=True, label="Adresse")
    telephone = forms.CharField(max_length=20, required=True, label="Numéro de téléphone")
    accept_cgv = forms.BooleanField(required=True, label="J'accepte les Conditions Générales de Vente")




