# Generated by Django 5.1.1 on 2024-10-12 15:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('billetterie', '0008_remove_transaction_offer_transaction_offer'),
    ]

    operations = [
        migrations.AlterField(
            model_name='transaction',
            name='total_price',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=8),
        ),
    ]
