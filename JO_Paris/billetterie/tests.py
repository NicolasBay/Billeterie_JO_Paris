from django.test import TestCase
from django.urls import reverse
from django.contrib.auth import get_user_model
from billetterie.models import Ticket

class TicketModelTest(TestCase):
    def setUp(self):
        self.ticket = Ticket.objects.create(
            name='SOLO',
            description='1 personne',
            price=50.00,
            nb_person=1
        )

    def test_ticket_creation(self):
        """Test que le ticket est créé correctement"""
        self.assertEqual(self.ticket.name, 'SOLO')
        self.assertEqual(self.ticket.description, '1 personne')
        self.assertEqual(self.ticket.price, 50.00)
        self.assertEqual(self.ticket.nb_person, 1)
    
    def test_string_representation(self):
        """Test que la représentation en chaine du ticket est correcte"""
        self.assertEqual(str(self.ticket), 'Offre Solo - 50.0')


class BilletViewTest(TestCase):

    def setUp(self):
        self.user = get_user_model().objects.create_user(
            email='testuser@example.com', password='testpassword'
        )
        self.ticket = Ticket.objects.create(
            name='DUO',
            description='2 personnes',
            price=90.00,
            nb_person=2
        )

    def test_billet_view_redirects_if_not_logged_in(self):
        """Test que la vue Billet redirige vers la page de connexion si l'utilisateur n'est pas authentifié"""
        response = self.client.get(reverse('billet'))
        self.assertRedirects(response, '/login/?next=/reserver-billet/')

    def test_billet_view_shows_tickets_if_logged_in(self):
        """Test que la vue Billet affiche les billets si l'utilisateur est authentifié"""
        self.client.login(email='testuser@example.com', password='testpassword')
        response = self.client.get(reverse('billet'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Choisissez votre Offre')
        self.assertContains(response, 'Duo')


class PanierTest(TestCase):

    def setUp(self):
        self.user = get_user_model().objects.create_user(
            email='test@example.com', password='testpass'
        )
        self.ticket = Ticket.objects.create(
            name='FAMILLE',
            description='Billet pour quatre personnes',
            price=160.00,
            nb_person=4
        )
        self.client.login(email='test@example.com', password='testpass')

    def test_add_ticket_to_cart(self):
        """Test que le billet est ajouté au panier"""
        response = self.client.post(reverse('billet'), {'ticket_id': self.ticket.id}) # Simule l'ajout d'un billet au panier via une requête POST
        self.assertRedirects(response, reverse('panier')) # Vérifie que l'utilisateur est redirigé vers la page du panier après l'ajout du billet.
        self.assertIn(str(self.ticket.id), self.client.session['panier']) # Vérifie que l'ID du billet est bien ajouté à la session du panier.


class CustomLoginViewTest(TestCase):

    def setUp(self):
        self.user = get_user_model().objects.create_user(
            email='testeur@example.com', password='testeurpass'
        )

    def test_login_redirects_to_billet_view(self):
        """Test que l'utilisateur est redirigé vers 'billet' après la connexion"""
        response = self.client.post(reverse('login'), {
            'email': 'testeur@example.com',
            'password': 'testeurpass'
        })
        self.assertRedirects(response, reverse('billet'))

    def test_login_shows_error_with_invalid_credentials(self):
        """Test que l'erreur est affichée si les identifiants sont incorrects"""
        response = self.client.post(reverse('login'), {
            'email': 'wronguser@example.com',
            'password': 'wrongpassword'
        })
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Identifiants invalides')


