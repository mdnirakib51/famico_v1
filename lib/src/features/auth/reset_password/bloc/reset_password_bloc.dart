import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repositories/auth_repo.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository = AuthRepository();

  ResetPasswordBloc() : super(const ResetPasswordState()) {
    on<ResetPasswordFieldChanged>(_onFieldChanged);
    on<ResetPasswordSubmitted>(_onResetPassword);
  }

  void _onFieldChanged(
      ResetPasswordFieldChanged event,
      Emitter<ResetPasswordState> emit,
      ) {
    switch (event.field) {
      case ResetPasswordField.password:
        emit(state.copyWith(password: event.value as String));
        break;
      case ResetPasswordField.confirmPassword:
        emit(state.copyWith(confirmPassword: event.value as String));
        break;
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordSubmitted event,
      Emitter<ResetPasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ResetPasswordStatus.loading));

      await _authRepository.reqResetPass(
        phoneEmail: event.phoneEmail,
        password: event.password,
      );

      emit(state.copyWith(status: ResetPasswordStatus.success));
    } catch (e) {
      log('Reset password error: ${e.toString()}');
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}