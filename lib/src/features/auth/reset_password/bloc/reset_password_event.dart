import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum ResetPasswordField { password, confirmPassword }

class ResetPasswordFieldChanged extends ResetPasswordEvent {
  final ResetPasswordField field;
  final dynamic value;

  ResetPasswordFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String phoneEmail;
  final String password;

  ResetPasswordSubmitted({
    required this.phoneEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneEmail, password];
}