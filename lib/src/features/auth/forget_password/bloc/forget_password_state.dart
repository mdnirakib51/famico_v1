import 'package:equatable/equatable.dart';

enum ForgetPasswordStatus { initial, loading, success, failure }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final String phoneEmail;
  final String? errorMessage;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.phoneEmail = '',
    this.errorMessage,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? phoneEmail,
    String? errorMessage,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      phoneEmail: phoneEmail ?? this.phoneEmail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phoneEmail, errorMessage];
}