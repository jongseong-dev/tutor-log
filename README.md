# tutor-log

과외 학생의 공부 일지를 기록하고, 그를 토대로 청구비를 발송하는 목적을 가진 웹 앱

## 개발 스택

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Django](https://img.shields.io/badge/django-%23092E20.svg?style=for-the-badge&logo=django&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)
![Celery](https://img.shields.io/badge/celery-%23a9cc54.svg?style=for-the-badge&logo=celery&logoColor=ddf4a4)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

## 개발 환경 설정하기

### 개요

- 개발환경은 혼자서 개발한다면 크게 중요하지 않을 수 있다. 하지만 여러명이서 개발한다면 동일한 환경에서 개발할 수 있도록 세팅해야한다.
- 이를 위해 인프라와 개발을 위한 라이브러리들을 쉽게 설치할 수 있도록 한다.

### 요구조건

1. python 버전은 `3.11.8`로 한다.
2. `pyenv`, `poetry`가 설치되어있다고 가정한다.
   - [pyenv 설치 방법](https://github.com/pyenv/pyenv) 
   - [poetry 설치 방법](https://python-poetry.org/docs/)
3. `docker` 및 `docker-compose`가 설치되어 있어야 한다.
    - [docker 설치하기](https://docs.docker.com/engine/install/)
4. `Make` 명령어를 실행시킬 수 있어야 한다. 아래는 패키지 관리자를 통해 Make를 설치하는 방법이다.
    - Linux: `brew install make`
    - Windows: `choco install make`
5. `linux` 환경에서 개발한다고 가정한다. Windows의 경우 make 실행은 `wsl2` 에서 실행하여야 한다.

### 개발환경 설정하기

```bash
# 가상환경 세팅
make virtualenv

# 필요한 의존성 세팅(db, redis, library 등)
make setting

# celery flower 실행
make celery-flower

# 테스트 코드 실행
make test
```

### 환경변수

- :exclamation: NOTE: 프로덕션 환경에 배포할 때는 환경변수를 주입해주세요.
- 현재 docker image를 빌드할 떄 `.env` 파일은 빌드되지 않도록 해놨습니다.

| Key                   | 설명                   | Default<br/>(개발을 용이하기 위해 기본값을 넣었으나, <br/> **배포 환경**에서는 변경해주세요.) |
|-----------------------|----------------------|-----------------------------------------------------------------|
| DJANGO_SETTING_MODULE | django의 실행 환경을 의미한다. | config.settings.local(Makefile에서 제공)                            | 
| DJANGO_SECRET_KEY     | django에서 사용되는 비밀키    | local(Makefile에서 제공)                                            |
| DB_NAME               | DB 이름                | webapp                                                          |
| DB_USER               | DB 접속 유저             | admin                                                           |
| DB_PASSWORD           | DB 접속 비밀번호           | admin                                                           |
| DB_HOST               | DB 호스트               | localhost                                                       |
| DB_PORT               | DB 포트                | 5432                                                            |
| CELERY_BROKER         | CELERY BROKER 종류     | redis                                                           |
| CELERY_BROKER_HOST    | CELERY BROKER 호스트    | localhost                                                       |
| CELERY_BROKER_PORT    | CELERY BROKER 포트     | 6379                                                            |
| CELERY_BROKER_DB      | CELERY BROKER DB 이름  | 0                                                               |

### 모니터링 도구

- 개발환경에서 모니터링은 굳이 구현하지 않아도 된다.
- 다만 프로덕션 레벨에서는 모니터링이 필수이다.
- 현재 로컬환경에서 모니터링 환경을 구축하는 법을 소개하고, 프로덕션 레벨에서 구현할 때의 문서는 업데이트 예정이다.
- [모니터링 환경 구축기](./docs/monitoring.md)

## 사용자 시나리오

- 사용자의 역할을 구분한다.
- 사용자가 어떤 행동을 할 수 있는지 정한다.
- 사용자의 제약사항들을 정의한다.
- 이를 통해 기능 요구사항을 도출하고, 개발 및 테스트를 진행한다.
- `BDD`를 통해 이해할 수 있는 테스트 시나리오를 작성한다.
   -  [TDD vs BDD](https://blog.wakmusic.xyz/tdd-vs-bdd-c738b507930f)

- [사용자 시나리오](./docs/user_scenario.md)