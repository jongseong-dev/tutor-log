# tutor-log

과외 학생의 공부 일지를 기록하고, 그를 토대로 청구비를 발송하는 목적을 가진 웹 앱

# 전략 수립

## 프로젝트 관리

- 프로젝트는 [github projects](https://github.com/users/jongseong-dev/projects/9/views/1)를 통해 관리한다.

## CI/CD

- 기본적으로 github flow를 따르도록 하며 main에 merge가
  되면 [docker hub](https://hub.docker.com/repository/docker/dlwhdtjd012/tytor-log/general)에 이미지가 등록되고 추후 aws ec2에 배포되도록
  한다.

## 인증 방식

- 인증은 OAuth2를 통해 Google 로그인을 제공할 예정

## 모놀리식 웹 앱

- Django template을 활용한 모놀리식 웹 앱이므로 front-end는 없음
- 다만 몇몇 api는 rest-api로 제공할 예정이므로 swagger를 제공할 예정

## 서버 아키텍쳐

- Nginx + gunicorn + Was(Django) + Celery(+RabbitMQ)
- 모니터링 도구: Sentry, Grafana + Prometheus
- 알림 도구: Email, Slack

# 구현하기

## 시나리오

### 그룹 등록

- 학생들은 지역 혹은 특정 그룹으로 등록할 수 있다.
- 이는 일정 등록 혹은 메시지를 발송 할 때 그룹으로 보낼 수 있게 한다.

### 일정 등록

- 학생을 가르치는 선생님은 학생들이 참여한 날짜를 캘린더에 기록한다.
- 그룹으로 캘린더에 등록할 수 있고, 혹은 개개인으로 등록할 수 있다.

### 비용 처구

- 선생님이 정해둔 특정 횟수가 채워지면 선생님에게 알려준다.
- 선생님은 비용청구를 할 때 학생들의 부모님 혹은 비용 청구 대상자에게 문자 혹은 메시지를 보낸다.

## DB 설계

- StudyLog(공부할 일자 기록)
- StudyGroup(공부한 학생들이 속한 그룹)
- Student(학생 정보)
- Todo(학생들에게 내준 할일 목록)
- MessageLog(메시지를 보낸 기록)