from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.models import PermissionsMixin
from django.contrib.postgres.indexes import GinIndex
from django.db import models

from account.managers import ActiveTeacherManager, CustomUserManger
from account.consts import ModelChoices
from common.models import CreateUpdateDateTimeModel
from config.settings.base import AUTH_USER_MODEL


class User(AbstractBaseUser, CreateUpdateDateTimeModel, PermissionsMixin):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=255, db_comment="사용자 이름")
    ip_addr = models.GenericIPAddressField(
        blank=True, null=True, db_comment="접속한 IP 주소"
    )
    last_login = models.DateTimeField(
        blank=True, null=True, db_comment="마지막 로그인 시간"
    )
    provider = models.CharField(max_length=50, blank=True, db_comment="OAuth2 제공자")
    uid = models.CharField(
        max_length=255,
        blank=True,
        db_comment="OAuth2 제공자로부터 받은 고유 ID",
    )
    is_active = models.BooleanField(default=True, db_comment="활성화 여부")
    is_staff = models.BooleanField(default=False, db_comment="관리자 여부")
    is_superuser = models.BooleanField(default=False, db_comment="슈퍼유저 여부")

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomUserManger()

    def __str__(self):
        return self.email

    class Meta:
        db_table_comment = "회원"


class Profile(CreateUpdateDateTimeModel):
    user = models.OneToOneField(AUTH_USER_MODEL, on_delete=models.CASCADE)
    phone = models.CharField(max_length=20, blank=True, db_comment="전화번호")
    addr = models.CharField(max_length=255, blank=True, db_comment="주소")
    detail_addr = models.CharField(max_length=255, blank=True, db_comment="상세주소")
    zip = models.CharField(max_length=255, blank=True, db_comment="우편번호")
    role = models.CharField(
        choices=ModelChoices.ROLE_CHOICES,
        max_length=50,
        db_comment="역할(선생, 학생, 학부모 등)",
    )
    date_of_birth = models.DateField(blank=True, null=True)

    def __str__(self):
        return f"{self.user.email} Profile"

    class Meta:
        db_table_comment = "사용자 프로필"


class Teacher(CreateUpdateDateTimeModel):
    user = models.OneToOneField(AUTH_USER_MODEL, on_delete=models.CASCADE)
    name = models.CharField(max_length=255, blank=True, db_comment="이름")
    zip = models.CharField(max_length=255, blank=True, db_comment="우편번호")
    addr = models.CharField(max_length=255, blank=True, db_comment="주소")
    detail_addr = models.CharField(max_length=255, blank=True, db_comment="상세주소")
    gender = models.CharField(choices=ModelChoices.GENDER_CHOICES, max_length=1)
    subject = models.ManyToManyField(
        "Subject",
        related_name="teachers",
        through="TeacherSubject",
    )
    like = models.ManyToManyField(
        AUTH_USER_MODEL, through="TeacherLike", related_name="liked_teachers"
    )
    total_like = models.IntegerField(default=0, db_comment="좋아요 수")
    objects = models.Manager()
    active_objects = ActiveTeacherManager()

    def __str__(self):
        return f"{self.name}"

    def get_absolute_url(self):
        # TODO: 나중에 구현
        pass

    class Meta:
        db_table_comment = "선생님 테이블"
        ordering = ["-total_like", "create_datetime"]
        indexes = [
            GinIndex(fields=["name"]),
            GinIndex(fields=["addr", "detail_addr"]),
        ]


class TeacherLike(CreateUpdateDateTimeModel):
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    user = models.ForeignKey(AUTH_USER_MODEL, on_delete=models.CASCADE)

    class Meta:
        db_table_comment = "선생님 평판 관리"


class Subject(CreateUpdateDateTimeModel):
    name = models.CharField(max_length=255, db_comment="과목 이름")

    def __str__(self):
        return self.name

    class Meta:
        db_table_comment = "과목 테이블"


class TeacherSubject(CreateUpdateDateTimeModel):
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)

    class Meta:
        db_table_comment = "선생님이 가르치는 과목 목록"


class MessageTemplate(CreateUpdateDateTimeModel):
    title = models.CharField(max_length=255, db_comment="템플릿 이름")
    content = models.TextField(db_comment="템플릿 내용")
    is_active = models.BooleanField(default=True, db_comment="활성화 여부")
    owner_id = models.ForeignKey(
        Teacher, on_delete=models.CASCADE, db_comment="템플릿 소유자"
    )

    def __str__(self):
        return f"{self.title}"

    class Meta:
        db_table_comment = "메시지 템플릿"
        ordering = ["-create_datetime"]
