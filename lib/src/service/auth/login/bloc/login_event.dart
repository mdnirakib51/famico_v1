import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginFieldChanged extends LoginEvent {
  final LoginField field;
  final dynamic value;

  LoginFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

enum LoginField { email, password, rememberMe}
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoadSavedCredentials extends LoginEvent {}