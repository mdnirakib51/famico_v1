
import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String email;
  final String password;
  final bool rememberMe;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    bool? rememberMe,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, password, rememberMe, errorMessage];
}
