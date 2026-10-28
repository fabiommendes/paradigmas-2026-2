from typing import NewType

# class Email:
#     _value: str
#     @property
#     def value(self) -> str:
#         return self._value
#     def __init__(self, value: str):
#         if not is_valid_email(value):
#             raise ValueError(value)
#         self._value = value


Email = NewType("Email", str)


def is_valid_email(value: str) -> bool:
    return "@" in value


def create_email(value: str) -> Email:
    if not is_valid_email(value):
        raise ValueError(value)
    return Email(value)


my_email : Email = create_email("foo@bar")

my_email_2 : Email = "foo@bar"

my_str : str = my_email