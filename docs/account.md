# 사용자 App 


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

## 트러블 슈팅

### django-allauth lib APP Name 충돌

- 기존의 `account` app과 all auth account 앱의 충돌이 발생
- All Auth App Config에서 label을 수정하려고 해봤지만, 실패
- `account` app의 label 이름을 변경하여서 다시 migrate 함
- 다만 이렇게 하면 기존의 migration한 버저닝과 어떤 오류가 생길지 모르므로 `social-auth-app-django`로 선회