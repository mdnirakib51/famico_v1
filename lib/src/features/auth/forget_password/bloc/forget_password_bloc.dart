import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repositories/auth_repo.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final AuthRepository _authRepository = AuthRepository();
  Timer? _timer;

  static const int _timerDuration = 180;

  ForgetPasswordBloc() : super(const ForgetPasswordState()) {
    on<ForgetPasswordFieldChanged>(_onFieldChanged);
    on<ForgetPasswordSubmitted>(_onSendOtp);
    on<ForgetPasswordOtpChanged>(_onOtpChanged);
    on<ForgetPasswordOtpSubmitted>(_onOtpSubmitted);
    on<ForgetPasswordResendOtp>(_onResendOtp);
    on<ForgetPasswordTimerTicked>(_onTimerTicked);
    on<ForgetPasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgetPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgetPasswordResetSubmitted>(_onResetSubmitted);
  }

  // ── Field Changed ──────────────────────────────────────────
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

  // ── Step 1: Send OTP ───────────────────────────────────────
  Future<void> _onSendOtp(
      ForgetPasswordSubmitted event,
      Emitter<ForgetPasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ForgetPasswordStatus.loading));

      // শুধু email যাবে
      await _authRepository.reqForgetPass(email: event.phoneEmail);

      emit(state.copyWith(
        status: ForgetPasswordStatus.initial,
        step: ForgetPasswordStep.otp,
        timerSeconds: _timerDuration,
        isTimerRunning: true,
        otp: '',
      ));

      _startTimer();
    } catch (e) {
      log('ForgetPasswordBloc - Send OTP error: $e');
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── OTP Field Changed ──────────────────────────────────────
  void _onOtpChanged(
      ForgetPasswordOtpChanged event,
      Emitter<ForgetPasswordState> emit,
      ) {
    emit(state.copyWith(otp: event.otp));
  }

  // ── Step 2: OTP Submitted → go to password step ───────────
  void _onOtpSubmitted(
      ForgetPasswordOtpSubmitted event,
      Emitter<ForgetPasswordState> emit,
      ) {
    _timer?.cancel();
    emit(state.copyWith(
      step: ForgetPasswordStep.newPassword,
      isTimerRunning: false,
    ));
  }

  // ── Resend OTP ─────────────────────────────────────────────
  Future<void> _onResendOtp(
      ForgetPasswordResendOtp event,
      Emitter<ForgetPasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ForgetPasswordStatus.loading));

      // শুধু email যাবে
      await _authRepository.reqForgetPass(email: state.phoneEmail);

      emit(state.copyWith(
        status: ForgetPasswordStatus.initial,
        timerSeconds: _timerDuration,
        isTimerRunning: true,
        otp: '',
      ));

      _startTimer();
    } catch (e) {
      log('ForgetPasswordBloc - Resend OTP error: $e');
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Timer Tick ─────────────────────────────────────────────
  void _onTimerTicked(
      ForgetPasswordTimerTicked event,
      Emitter<ForgetPasswordState> emit,
      ) {
    if (event.remainingSeconds > 0) {
      emit(state.copyWith(timerSeconds: event.remainingSeconds));
    } else {
      emit(state.copyWith(
        timerSeconds: 0,
        isTimerRunning: false,
      ));
    }
  }

  // ── Password Fields Changed ────────────────────────────────
  void _onNewPasswordChanged(
      ForgetPasswordNewPasswordChanged event,
      Emitter<ForgetPasswordState> emit,
      ) {
    emit(state.copyWith(newPassword: event.newPassword));
  }

  void _onConfirmPasswordChanged(
      ForgetPasswordConfirmPasswordChanged event,
      Emitter<ForgetPasswordState> emit,
      ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  // ── Step 3: Reset Password ─────────────────────────────────
  Future<void> _onResetSubmitted(
      ForgetPasswordResetSubmitted event,
      Emitter<ForgetPasswordState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ForgetPasswordStatus.loading));

      // email + otp + newPassword তিনটাই যাবে
      await _authRepository.reqForgetPass(
        email: state.phoneEmail,
        otp: int.tryParse(state.otp),
        newPassword: state.newPassword,
      );

      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } catch (e) {
      log('ForgetPasswordBloc - Reset password error: $e');
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Timer Helper ───────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.timerSeconds - 1;
      add(ForgetPasswordTimerTicked(remainingSeconds: remaining));
      if (remaining <= 0) timer.cancel();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}