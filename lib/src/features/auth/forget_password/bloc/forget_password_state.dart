import 'package:equatable/equatable.dart';

enum ForgetPasswordStatus { initial, loading, success, failure }

enum ForgetPasswordStep { email, otp, newPassword }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final ForgetPasswordStep step;
  final String phoneEmail;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final int timerSeconds;
  final bool isTimerRunning;
  final String? errorMessage;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.step = ForgetPasswordStep.email,
    this.phoneEmail = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.timerSeconds = 180, // 3 minutes
    this.isTimerRunning = false,
    this.errorMessage,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    ForgetPasswordStep? step,
    String? phoneEmail,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    int? timerSeconds,
    bool? isTimerRunning,
    String? errorMessage,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      step: step ?? this.step,
      phoneEmail: phoneEmail ?? this.phoneEmail,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      errorMessage: errorMessage,
    );
  }

  bool get isOtpComplete => otp.length == 6;

  bool get isPasswordValid =>
      newPassword.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          newPassword == confirmPassword;

  @override
  List<Object?> get props => [
    status,
    step,
    phoneEmail,
    otp,
    newPassword,
    confirmPassword,
    timerSeconds,
    isTimerRunning,
    errorMessage,
  ];
}