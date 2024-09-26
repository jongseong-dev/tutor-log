#!/bin/sh

cd webapp
if [ "$DJANGO_SETTINGS_MODULE" = "config.settings.local" ]; then
  python manage.py migrate
  python manage.py runserver 0.0.0.0:8000
elif [ "$DJANGO_SETTINGS_MODULE" = "config.settings.test" ]; then
  python manage.py test
fi