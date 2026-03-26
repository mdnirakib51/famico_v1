import 'package:equatable/equatable.dart';

enum UpdateProfileStatus { initial, loading, success, failure }

class UpdateProfileState extends Equatable {
  final UpdateProfileStatus status;
  final String name;
  final String phone;
  final String email;
  final String dob;
  final int age;
  final String? errorMessage;

  const UpdateProfileState({
    this.status = UpdateProfileStatus.initial,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.dob = '',
    this.age = 0,
    this.errorMessage,
  });

  UpdateProfileState copyWith({
    UpdateProfileStatus? status,
    String? name,
    String? phone,
    String? email,
    String? dob,
    int? age,
    String? errorMessage,
  }) {
    return UpdateProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, name, phone, email, dob, age, errorMessage];
}