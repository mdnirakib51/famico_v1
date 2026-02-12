import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../bloc/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoadSavedCredentials>(_onLoadSavedCredentials);
    on<LoginFieldChanged>(_onFieldChanged);
    on<LoginSubmitted>(_onLoginSubmitted);

    add(LoadSavedCredentials());
  }

  Future<void> _onLoadSavedCredentials(LoadSavedCredentials event, Emitter<LoginState> emit) async {
    try {
      final credentials = AuthService.loadSavedCredentials();
      emit(state.copyWith(
        email: credentials['email'] ?? '',
        password: credentials['password'] ?? '',
        rememberMe: credentials['remember_me'] ?? false,
      ));
    } catch (e) {
      log('Error loading saved credentials: ${e.toString()}');
    }
  }

  Future<void> _onFieldChanged(LoginFieldChanged event,Emitter<LoginState> emit) async {
    // Handle different field changes
    switch (event.field) {
      case LoginField.email:
        emit(state.copyWith(email: event.value as String));
        break;
      case LoginField.password:
        emit(state.copyWith(password: event.value as String));
        break;
      case LoginField.rememberMe:
        emit(state.copyWith(rememberMe: event.value as bool));
        break;
    }

    _saveCredentialsIfRemembered();
  }

  void _saveCredentialsIfRemembered() {
    if (state.rememberMe) {
      AuthService.saveCredentials(
        email: state.email,
        password: state.password,
        rememberMe: state.rememberMe,
      );
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      if (state.rememberMe) {
        AuthService.saveCredentials(
          email: event.email,
          password: event.password,
          rememberMe: state.rememberMe,
        );
      }

      await Future.delayed(Duration(seconds: 1));

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        log('Login successful for: ${event.email}');
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Email and password cannot be empty',
        ));
      }
    } catch (e) {
      log('Login error: ${e.toString()}');
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}