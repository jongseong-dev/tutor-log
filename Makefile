DJANGO_WORKDIR = webapp

.PHONY: install infra celery migration test clean

setting_for_windows: install infra celery_for_windows migration
setting: install infra celery migration

install:
	@echo "Installing dependencies..."
	poetry install --no-root

# 개발 관련 컨테이너 실행
infra:
	@echo "Run infrastructure containers needed for the development environment."
	docker-compose -f infra/docker-compose.yml up --build -d

celery_for_windows:
	@echo "Run celery worker for window"
	cd ${DJANGO_WORKDIR} && \
	celery -A config worker -l info -P gevent && \
	celery -A config beat -l info -P gevent && \
	celery -A config flower -P gevent

celery:
	@echo "Run celery worker"
	cd ${DJANGO_WORKDIR} && \
	celery -A config worker -l info && \
	celery -A config beat -l info && \
	celery -A config flower

migration:
	@echo "Migration..."
	cd ${DJANGO_WORKDIR} && \
	python manage.py migrate


# 테스트 실행
test: infra celery migration
	@echo "Running tests..."
	cd ${DJANGO_WORKDIR} && \
	pytest

# 캐시 파일 및 마이그레이션 파일 정리
clean:
	@echo "Cleaning up..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -path "*/migrations/*.py" -not -name "__init__.py" -delete
	find . -type f -path "*/migrations/*.pyc" -delete