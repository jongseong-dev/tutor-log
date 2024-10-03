DJANGO_WORKDIR = webapp
DJANGO_SETTINGS_MODULE = config.settings.local
DJANGO_SECRET_KEY = local
CELERY_APP_NAME = config
IS_CELERY_RUN = $(shell pgrep -f "celery -A $(CELERY_APP_NAME) worker")

.PHONY:  virtualenv create-env install infra celery migration test clean

virtualenv:
	@echo "Virtualenv with poetry and pyenv. Python version: 3.11.8"
	pyenv local 3.11.8
	poetry env use 3.11.8
	poetry shell

setting: create-env install infra celery migration
	@ehco "Setting up dependencies required for development "

create-env:
	@echo "Create env file"
	@echo "If exist env file skip this processing..."
	@if [ -f $(DJANGO_WORKDIR)/.env ]; then \
		echo "already exist file."; \
	else \
		echo "DJANGO_SETTINGS_MODULE=$(DJANGO_SETTINGS_MODULE)" > $(DJANGO_WORKDIR)/.env; \
		echo "DJANGO_SECRET_KEY=$(DJANGO_SECRET_KEY)" >> $(DJANGO_WORKDIR)/.env; \
		cat $(DJANGO_WORKDIR)/.env; \
	fi

install:
	@echo "Installing dependencies..."
	poetry install --no-root

infra:
	@echo "Run infrastructure containers needed for the development environment."
	docker-compose -f infra/docker-compose.yml up --build -d

migration:
	@echo "Migration..."
	cd ${DJANGO_WORKDIR} && \
	python manage.py migrate

celery: celery-worker celery-beat

celery-worker:
	@echo "Run celery worker"
	@if [-z "$(IS_CELERY_RUN)" ]; then \
		cd ${DJANGO_WORKDIR} && \
		celery -A $(CELERY_APP_NAME) worker --detach -l info -P gevent -n webappworker@%h; \
	else \
	  	echo "Celery is already running..."; \
	fi

celery-beat:
	@echo "Run celery beat"
	cd ${DJANGO_WORKDIR} && \
	celery -A $(CELERY_APP_NAME) beat --detach -l info

celery-flower:
	@echo "Run celery flower"
	cd ${DJANGO_WORKDIR} && \
	celery -A $(CELERY_APP_NAME) flower -P gevent -p 5555:5555


test: infra celery-worker
	@echo "Running tests..."
	cd ${DJANGO_WORKDIR} && \
	pytest

clean:
	@echo "Cleaning up..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -path "*/migrations/*.py" -not -name "__init__.py" -delete
	find . -type f -path "*/migrations/*.pyc" -delete