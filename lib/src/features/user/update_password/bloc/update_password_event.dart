import 'package:equatable/equatable.dart';

abstract class UpdatePasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

enum UpdatePasswordField { oldPassword, newPassword, confirmPassword }

class UpdatePasswordFieldChanged extends UpdatePasswordEvent {
  final UpdatePasswordField field;
  final String value;

  UpdatePasswordFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class UpdatePasswordSubmitted extends UpdatePasswordEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordSubmitted({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}