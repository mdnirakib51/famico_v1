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
      case UpdateProfileField.dialCode:
        emit(state.copyWith(dialCode: event.value as String));
        break;
      case UpdateProfileField.phone:
        emit(state.copyWith(phone: event.value as String));
        break;
      case UpdateProfileField.gender:
        emit(state.copyWith(gender: event.value as String));
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
        dialCode: event.dialCode,
        phone: event.phone,
        gender: event.gender,
        dob: event.dob,
        age: event.age,
      );

      emit(state.copyWith(status: UpdateProfileStatus.success));
    } catch (e) {
      log('UpdateProfileBloc - Submit error: $e');
      emit(state.copyWith(
        status: UpdateProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}