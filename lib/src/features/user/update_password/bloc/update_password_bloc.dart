import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import 'update_password_event.dart';
import 'update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  final UserRepository _userRepository = UserRepository();

  UpdatePasswordBloc() : super(const UpdatePasswordState()) {
    on<UpdatePasswordFieldChanged>(_onFieldChanged);
    on<UpdatePasswordSubmitted>(_onSubmit);
  }

  void _onFieldChanged(
      UpdatePasswordFieldChanged event,
      Emitter<UpdatePasswordState> emit,
      ) {
    switch (event.field) {
      case UpdatePasswordField.oldPassword:
        emit(state.copyWith(oldPassword: event.value));
        break;
      case UpdatePasswordField.newPassword:
        emit(state.copyWith(newPassword: event.value));
        break;
      case UpdatePasswordField.confirmPassword:
        emit(state.copyWith(confirmPassword: event.value));
        break;
    }
  }

  Future<void> _onSubmit(
      UpdatePasswordSubmitted event,
      Emitter<UpdatePasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: UpdatePasswordStatus.loading));

      await _userRepository.reqUpdatePass(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      emit(state.copyWith(status: UpdatePasswordStatus.success));
    } catch (e) {
      log('UpdatePasswordBloc error: $e');
      emit(state.copyWith(
        status: UpdatePasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}