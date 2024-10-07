from django.db import migrations


def create_initial_subjects(apps, schema_editor):
    # Subject 모델을 가져옵니다.
    Subject = apps.get_model("account", "Subject")

    # 초기 데이터를 정의합니다.
    initial_subjects = [
        {"name": "국어"},
        {"name": "영어"},
        {"name": "수학"},
        {"name": "과학"},
        {"name": "사회"},
    ]

    # Subject 모델에 데이터를 삽입합니다.
    for subject_data in initial_subjects:
        Subject.objects.create(**subject_data)


class Migration(migrations.Migration):

    dependencies = [
        # 이전 마이그레이션 파일을 지정합니다.
        ("account", "0001_initial"),  # 예: '0001_initial'
    ]

    operations = [
        # 데이터 추가를 위한 함수 호출
        migrations.RunPython(create_initial_subjects),
    ]
