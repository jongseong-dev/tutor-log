from dataclasses import dataclass


@dataclass(frozen=True)
class ModelChoices:
    GENDER_CHOICES = [("M", "male"), ("F", "female")]
    ROLE_CHOICES = [
        ("T", "teacher"),
        ("S", "student"),
        ("P", "parent"),
    ]
