import 'package:equatable/equatable.dart';

abstract class UpdateProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum UpdateProfileField { name, phone, email, dob, age }

class UpdateProfileFieldChanged extends UpdateProfileEvent {
  final UpdateProfileField field;
  final dynamic value;

  UpdateProfileFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class UpdateProfileSubmitted extends UpdateProfileEvent {
  final String name;
  final String phone;
  final String email;
  final String dob;
  final int age;

  UpdateProfileSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.age,
  });

  @override
  List<Object?> get props => [name, phone, email, dob, age];
}