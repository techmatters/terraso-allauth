import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

INSTALLED_APPS = (
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.sites",
    "allauth",
    "allauth.account",
    "allauth.socialaccount",
    "terraso_allauth",
)

SECRET_KEY = "any-key-for-testing-purposes"

SITE_ID = 1
ROOT_URLCONF = "tests.urls"
