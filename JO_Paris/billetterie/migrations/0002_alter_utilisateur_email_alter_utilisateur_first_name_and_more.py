# Generated by Django 5.1.1 on 2024-10-06 10:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('billetterie', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='utilisateur',
            name='email',
            field=models.EmailField(blank=True, max_length=254, verbose_name='email address'),
        ),
        migrations.AlterField(
            model_name='utilisateur',
            name='first_name',
            field=models.CharField(blank=True, max_length=150, verbose_name='first name'),
        ),
        migrations.AlterField(
            model_name='utilisateur',
            name='last_name',
            field=models.CharField(blank=True, max_length=150, verbose_name='last name'),
        ),
        migrations.AlterField(
            model_name='utilisateur',
            name='password',
            field=models.CharField(max_length=128, verbose_name='password'),
        ),
    ]
