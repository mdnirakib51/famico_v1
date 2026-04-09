import 'package:equatable/equatable.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

enum UpdateProfileField { name, dialCode, phone, gender, dob, age }

class UpdateProfileFieldChanged extends UpdateProfileEvent {
  final UpdateProfileField field;
  final dynamic value;

  const UpdateProfileFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class UpdateProfileSubmitted extends UpdateProfileEvent {
  final String name;
  final String dialCode;
  final String phone;
  final String gender;
  final String dob;
  final int age;

  const UpdateProfileSubmitted({
    required this.name,
    required this.dialCode,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.age,
  });

  @override
  List<Object?> get props => [name, dialCode, phone, gender, dob, age];
}