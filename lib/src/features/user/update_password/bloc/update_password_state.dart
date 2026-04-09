import 'package:equatable/equatable.dart';

enum UpdatePasswordStatus { initial, loading, success, failure }

class UpdatePasswordState extends Equatable {
  final UpdatePasswordStatus status;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final String? errorMessage;

  const UpdatePasswordState({
    this.status = UpdatePasswordStatus.initial,
    this.oldPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  UpdatePasswordState copyWith({
    UpdatePasswordStatus? status,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return UpdatePasswordState(
      status: status ?? this.status,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, oldPassword, newPassword, confirmPassword, errorMessage];
}