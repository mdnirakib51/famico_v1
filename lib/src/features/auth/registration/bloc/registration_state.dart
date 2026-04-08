import 'package:equatable/equatable.dart';

enum RegistrationStatus { initial, loading, success, failure }

class RegistrationState extends Equatable {
  final RegistrationStatus status;
  final String name;
  final String dialCode;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final String? errorMessage;

  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.name = '',
    this.dialCode = '+880',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? name,
    String? dialCode,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      name: name ?? this.name,
      dialCode: dialCode ?? this.dialCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    dialCode,
    phone,
    email,
    password,
    confirmPassword,
    errorMessage,
  ];
}