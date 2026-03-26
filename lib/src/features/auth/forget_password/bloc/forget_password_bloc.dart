import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repositories/auth_repo.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final AuthRepository _authRepository = AuthRepository();

  ForgetPasswordBloc() : super(const ForgetPasswordState()) {
    on<ForgetPasswordFieldChanged>(_onFieldChanged);
    on<ForgetPasswordSubmitted>(_onSendOtp);
  }

  void _onFieldChanged(
      ForgetPasswordFieldChanged event,
      Emitter<ForgetPasswordState> emit,
      ) {
    switch (event.field) {
      case ForgetPasswordField.phoneEmail:
        emit(state.copyWith(phoneEmail: event.value as String));
        break;
    }
  }

  Future<void> _onSendOtp(
      ForgetPasswordSubmitted event,
      Emitter<ForgetPasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ForgetPasswordStatus.loading));

      await _authRepository.reqSendOtp(phoneEmail: event.phoneEmail);

      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } catch (e) {
      log('Forget password error: ${e.toString()}');
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}