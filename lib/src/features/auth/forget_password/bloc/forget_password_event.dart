import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum ForgetPasswordField { phoneEmail }

class ForgetPasswordFieldChanged extends ForgetPasswordEvent {
  final ForgetPasswordField field;
  final dynamic value;

  ForgetPasswordFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class ForgetPasswordSubmitted extends ForgetPasswordEvent {
  final String phoneEmail;

  ForgetPasswordSubmitted({required this.phoneEmail});

  @override
  List<Object?> get props => [phoneEmail];
}