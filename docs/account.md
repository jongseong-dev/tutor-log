# 사용자 App

<!-- TOC -->
* [사용자 App](#사용자-app)
  * [OAuth2](#oauth2)
    * [도입 배경](#도입-배경)
    * [기능 구현](#기능-구현)
    * [선택한 라이브러리](#선택한-라이브러리)
    * [소셜 로그인 개발을 위한 준비](#소셜-로그인-개발을-위한-준비)
  * [OAuth2 API KEY 발급 방법](#oauth2-api-key-발급-방법)
    * [1. **Google OAuth2.0 설정**](#1-google-oauth20-설정)
    * [2. **Kakao OAuth2.0 설정**](#2-kakao-oauth20-설정)
    * [3. **Naver OAuth2.0 설정**](#3-naver-oauth20-설정)
  * [트러블 슈팅](#트러블-슈팅)
    * [django-allauth와 APP Name 충돌](#django-allauth와-app-name-충돌)
<!-- TOC -->

## OAuth2

### 도입 배경

- 사용자에게 소셜 로그인 기능을 제공함으로써 허들을 하나라도 낮추고자 함
- 부가 정보는 로그인 후 데이터를 받고자 한다.

### 기능 구현

- 사용자의 부가 정보는 소셜 로그인 이후 받도록 한다. 필수 요소로 받도록 한다.
- 소셜 로그인을 제공하는 것은 `google`, `kakao`, `naver` 이다.
- 소셜 로그인을 통해 받은 정보는 사용자의 정보로 저장한다.

### 선택한 라이브러리

- ~~django-allauth~~: 후술할 문제로 인해 사용안함
- social-auth-app-django: 소셜 로그인을 제공하는 라이브러리
    - 한 때 더 이상 업데이트가 되지 않는다는 이슈가 있었으나, 최근에 업데이트가 되었다.
    - [공식문서](https://python-social-auth.readthedocs.io/en/latest/configuration/django.html)

### 소셜 로그인 개발을 위한 준비

1. local에서 https 서버 띄우기
    1. `hosts` 파일을 수정하여 127.0.0.1을 해당 프로젝트의 **도메인**으로 변경한다.
        - ```text
           # hosts
           ...
           127.0.0.1 tutor.com
          ``` 
    2. `mkcert`를 이용하여서 local에서 ca 인증서를 발급 받는다.
        - `mkcert` 설치방법
            - Linux / MacOS: `brew install mkcert`
            - Windows: `choco install mkcert`
        - 인증서 발급 방법: `mkcert -cert-file cert.pem -key-file key.pem <DOMAIN> 127.0.0.1`
            - 위에서 설정한 `tutor.com`를 사용한다.
                - `mkcert -cert-file cert.pem -key-file key.pem tutor.com 127.0.0.1`
    3. 인증서를 발급 받은 후 `django_extensions`의 `runserver_plus`를 이용하여서 https 서버를 띄운다.
        - `python manage.py runserver_plus --cert-file cert.pem --key-file key.pem`

2. 소셜 로그인을 위한 API KEY 발급은 아래의 [문서 참조](#oauth2-api-key-발급-방법)

3. 해당 키를 발급 받으면 `.env` 파일에 저장한다.
    - ```text
      # .env
      GOOGLE_CLIENT_ID=<발급받은 client id>
      GOOGLE_SECRET_KEY=<발급받은 secret key>
      KAKAO_CLIENT_ID=<발급받은 client id>
      KAKAO_SECRET_KEY=<발급받은 secret key>
      NAVER_CLIENT_ID=<발급받은 client id>
      NAVER_SECRET_KEY=<발급받은 secret key>
      ```


## OAuth2 API KEY 발급 방법

### 1. **Google OAuth2.0 설정**

1. **Google Cloud Platform(GCP) 접속**: [GCP Console](https://console.cloud.google.com/)에 로그인합니다.
2. **프로젝트 생성**: 프로젝트를 생성한 후, "OAuth 동의 화면"을 설정합니다.
3. **OAuth 동의 화면 구성**: 애플리케이션의 이름, 이메일, 범위 등을 설정하고 저장합니다.
4. **OAuth 클라이언트 ID 발급**: API 및 서비스 > 사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID를 선택합니다. 애플리케이션 유형을 선택하고 리다이렉트 URI를 입력한
   후, 클라이언트 ID와 클라이언트 비밀 키를 발급받습니다.

### 2. **Kakao OAuth2.0 설정**

1. **카카오 개발자 콘솔 접속**: [카카오 개발자 콘솔](https://developers.kakao.com/)에 접속하여 로그인합니다.
2. **앱 생성**: "내 애플리케이션"에서 새로운 애플리케이션을 생성합니다.
3. **플랫폼 설정**: 앱 설정에서 플랫폼을 추가하고 Redirect URI를 입력합니다.
4. **REST API 키와 JavaScript 키 확인**: 애플리케이션 설정에서 REST API 키와 JavaScript 키를 확인합니다. REST API 키는 클라이언트 ID로 사용되며, 클라이언트 시크릿
   설정은 선택사항입니다.

### 3. **Naver OAuth2.0 설정**

1. **네이버 개발자 센터 접속**: [네이버 개발자 센터](https://developers.naver.com/)에 로그인하여 "내 애플리케이션"에서 새로운 애플리케이션을 생성합니다.
2. **애플리케이션 등록**: 서비스 URL, 리다이렉트 URI 등을 입력하고 애플리케이션을 등록합니다.
3. **Client ID와 Client Secret 발급**: 애플리케이션 등록이 완료되면 Client ID와 Secret을 발급받을 수 있습니다.
4. **OAuth2.0 인증 설정**: 등록한 애플리케이션의 "API 설정"에서 "네이버 아이디로 로그인"을 활성화하고, 필요 시 권한을 추가로 설정합니다.

- [구글 간편 로긍](https://goldenrabbit.co.kr/2023/08/07/oauth%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EA%B5%AC%EA%B8%80-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EC%9D%B8%EC%A6%9D%ED%95%98%EA%B8%B0-1%ED%8E%B8/)
- [카카오 간편 로그인 구현하기](https://bori-note.tistory.com/57)
- [네이버 로그인을 위한 OAuth2.0 설정 및 Access Token 발급 방법](https://kimmjieun.tistory.com/63)


## 트러블 슈팅

### django-allauth와 APP Name 충돌

- 기존의 `account` app과 all auth account 앱의 충돌이 발생
- All Auth App Config에서 label을 수정하려고 해봤지만, 실패
- `account` app의 label 이름을 변경하여서 다시 migrate 함
- 다만 이렇게 하면 기존의 migration한 버저닝과 어떤 오류가 생길지 모르므로 `social-auth-app-django`로 선회
