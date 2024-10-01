#!/bin/sh

set -e

# 실제 폴더 이동
cd webapp || { echo "Error: Failed to change directory to webapp"; exit 1; }

# 데이터베이스 연결 확인
echo "Check database connection"
python manage.py check --database default

if [ "$DJANGO_SETTINGS_MODULE" = "config.settings.local" ]; then
  python manage.py migrate
  python manage.py runserver 0.0.0.0:8000
elif [ "$DJANGO_SETTINGS_MODULE" = "config.settings.test" ]; then
  python manage.py test
else
  echo "Error: DJANGO_SETTINGS_MODULE is not set to a recognized value"
  exit 1
fi