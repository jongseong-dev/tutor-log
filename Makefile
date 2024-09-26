# Django Project Makefile

.PHONY: install run migrate makemigrations shell test clean


# 의존성 설치
install:
	@echo "Installing dependencies..."
	poetry install

# 개발 관련 컨테이너 실행
infra:
	@echo "Run infrastructure containers needed for the development environment."
	docker-compose -f container/docker-compose.yml up --build -d

# 테스트 실행
test:
	@echo "Running tests..."
	cd webapp && pytest


# 캐시 파일 및 마이그레이션 파일 정리
clean:
	@echo "Cleaning up..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -path "*/migrations/*.py" -not -name "__init__.py" -delete
	find . -type f -path "*/migrations/*.pyc" -delete