import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import 'update_profile_event.dart';
import 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UserRepository _userRepository = UserRepository();

  UpdateProfileBloc() : super(const UpdateProfileState()) {
    on<UpdateProfileFieldChanged>(_onFieldChanged);
    on<UpdateProfileSubmitted>(_onSubmit);
  }

  void _onFieldChanged(
      UpdateProfileFieldChanged event,
      Emitter<UpdateProfileState> emit,
      ) {
    switch (event.field) {
      case UpdateProfileField.name:
        emit(state.copyWith(name: event.value as String));
        break;
      case UpdateProfileField.phone:
        emit(state.copyWith(phone: event.value as String));
        break;
      case UpdateProfileField.email:
        emit(state.copyWith(email: event.value as String));
        break;
      case UpdateProfileField.dob:
        emit(state.copyWith(dob: event.value as String));
        break;
      case UpdateProfileField.age:
        emit(state.copyWith(age: event.value as int));
        break;
    }
  }

  Future<void> _onSubmit(
      UpdateProfileSubmitted event,
      Emitter<UpdateProfileState> emit,
      ) async {
    try {
      emit(state.copyWith(status: UpdateProfileStatus.loading));

      await _userRepository.reqUpdateProfile(
        name: event.name,
        phone: event.phone,
        email: event.email,
        dob: event.dob,
        age: event.age,
      );

      emit(state.copyWith(status: UpdateProfileStatus.success));
    } catch (e) {
      log('Update profile error: ${e.toString()}');
      emit(state.copyWith(
        status: UpdateProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}