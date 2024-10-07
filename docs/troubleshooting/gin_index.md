# Gin Index

## 개요

- 선생님 이름을 검색할 때 빠르게 하기 위해 `GinIndex`를 사용하려고 했다.
- 근데 해당 오류가 발생했다
```shell
django.db.utils.ProgrammingError: data type character varying has no default operator class for access method "gin"
HINT:  You must specify an operator class for the index or define a default operator class for the data type. 
```
## 해결 방법

- postgres에서 Gin-Btree extension을 설치해야 했다.

```sql
CREATE EXTENSION btree_gin;
```

- 이를 위해 `init.sql`에 추가했음