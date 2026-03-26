import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String password;
  final String confirmPassword;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? password,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, password, confirmPassword, errorMessage];
}