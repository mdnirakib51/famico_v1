import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

enum ForgetPasswordField { phoneEmail }

class ForgetPasswordFieldChanged extends ForgetPasswordEvent {
  final ForgetPasswordField field;
  final dynamic value;

  const ForgetPasswordFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class ForgetPasswordSubmitted extends ForgetPasswordEvent {
  final String phoneEmail;

  const ForgetPasswordSubmitted({required this.phoneEmail});

  @override
  List<Object?> get props => [phoneEmail];
}

class ForgetPasswordOtpChanged extends ForgetPasswordEvent {
  final String otp;

  const ForgetPasswordOtpChanged({required this.otp});

  @override
  List<Object?> get props => [otp];
}

class ForgetPasswordOtpSubmitted extends ForgetPasswordEvent {
  const ForgetPasswordOtpSubmitted();
}

class ForgetPasswordResendOtp extends ForgetPasswordEvent {
  const ForgetPasswordResendOtp();
}

class ForgetPasswordTimerTicked extends ForgetPasswordEvent {
  final int remainingSeconds;

  const ForgetPasswordTimerTicked({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];
}

class ForgetPasswordNewPasswordChanged extends ForgetPasswordEvent {
  final String newPassword;

  const ForgetPasswordNewPasswordChanged({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class ForgetPasswordConfirmPasswordChanged extends ForgetPasswordEvent {
  final String confirmPassword;

  const ForgetPasswordConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class ForgetPasswordResetSubmitted extends ForgetPasswordEvent {
  const ForgetPasswordResetSubmitted();
}