-- 테스트 데이터베이스 생성
CREATE DATABASE testdb;

-- 테스트 데이터베이스에 대한 권한 부여
GRANT ALL PRIVILEGES ON DATABASE testdb TO admin;

-- GIN Index를 생성할 수 있도록 Extension 설치
-- django migration으로 extension을 설치하지 않은 이유
-- 의존성이 밀접한 건 application level에서 최대한 낮추도록 하자
-- 만약 Mysql로 vendor가 바뀐다면 docker image로 된 app을 바꾸는 것을 최대한 지양하려고 했다.
CREATE EXTENSION IF NOT EXISTS btree_gin;