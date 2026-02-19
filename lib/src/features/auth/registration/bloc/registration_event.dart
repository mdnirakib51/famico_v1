import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum RegistrationField { username, phone, email, password, confirmPassword, agreeToTerms}

class RegistrationFieldChanged extends RegistrationEvent {
  final RegistrationField field;
  final dynamic value;

  RegistrationFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class RegistrationSubmitted extends RegistrationEvent {
  final String username;
  final String phone;
  final String email;
  final String password;

  RegistrationSubmitted({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, phone, email, password];
}