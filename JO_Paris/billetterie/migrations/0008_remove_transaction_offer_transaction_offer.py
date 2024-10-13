# Generated by Django 5.1.1 on 2024-10-12 14:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('billetterie', '0007_transaction_quantity'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='transaction',
            name='offer',
        ),
        migrations.AddField(
            model_name='transaction',
            name='offer',
            field=models.ManyToManyField(to='billetterie.ticket'),
        ),
    ]