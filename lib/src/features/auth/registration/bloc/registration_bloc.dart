import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repo.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository = AuthRepository();

  RegistrationBloc() : super(const RegistrationState()) {
    on<RegistrationFieldChanged>(_onFieldChanged);
    on<RegistrationSubmitted>(_reqRegister);
    on<RegistrationWithGoogleRequested>(_onGoogleRegister);
    on<RegistrationWithFacebookRequested>(_onFacebookRegister);
  }

  Future<void> _onFieldChanged(
      RegistrationFieldChanged event,
      Emitter<RegistrationState> emit,
      ) async {
    switch (event.field) {
      case RegistrationField.username:
        emit(state.copyWith(name: (event.value as String).toLowerCase()));
        break;
      case RegistrationField.dialCode:
        emit(state.copyWith(dialCode: event.value as String));
        break;
      case RegistrationField.phone:
        emit(state.copyWith(phone: event.value as String));
        break;
      case RegistrationField.email:
        emit(state.copyWith(email: event.value as String));
        break;
      case RegistrationField.password:
        emit(state.copyWith(password: event.value as String));
        break;
      case RegistrationField.confirmPassword:
        emit(state.copyWith(confirmPassword: event.value as String));
        break;
      case RegistrationField.agreeToTerms:
        break;
    }
  }

  Future<void> _reqRegister(
      RegistrationSubmitted event,
      Emitter<RegistrationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: RegistrationStatus.loading));

      final AuthModel response = await _authRepository.reqRegistration(
        username: event.username,
        email: event.email,
        dialCode: event.dialCode,   // ← passed through
        phone: event.phone,
        password: event.password,
      );

      if (response.token != null) {
        _authRepository.requestHandler.updateHeader(token: response.token ?? '');
      }

      emit(state.copyWith(status: RegistrationStatus.success));
    } catch (e) {
      log('Registration error: ${e.toString()}');
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGoogleRegister(
      RegistrationWithGoogleRequested event,
      Emitter<RegistrationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: RegistrationStatus.loading));
      // TODO: Google Sign-In integration
      log('Google registration requested');
      emit(state.copyWith(status: RegistrationStatus.initial));
    } catch (e) {
      log('Google registration error: ${e.toString()}');
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFacebookRegister(
      RegistrationWithFacebookRequested event,
      Emitter<RegistrationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: RegistrationStatus.loading));
      // TODO: Facebook Login integration
      log('Facebook registration requested');
      emit(state.copyWith(status: RegistrationStatus.initial));
    } catch (e) {
      log('Facebook registration error: ${e.toString()}');
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}