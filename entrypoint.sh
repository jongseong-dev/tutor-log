#!/bin/sh

cd webapp
# Django 애플리케이션을 실행합니다.
if [ "$DJANGO_SETTINGS_MODULE" = "config.settings.local" ]; then
  python manage.py migrate
  python manage.py runserver 0.0.0.0:8000
elif [ "$DJANGO_SETTINGS_MODULE" = "config.settings.test" ]; then
  python manage.py test