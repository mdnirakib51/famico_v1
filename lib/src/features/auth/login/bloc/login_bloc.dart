import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();

  LoginBloc() : super(const LoginState()) {
    on<LoadSavedCredentials>(_onLoadSavedCredentials);
    on<LoginFieldChanged>(_onFieldChanged);
    on<LoginSubmitted>(_reqLogIn);

    add(LoadSavedCredentials());
  }

  Future<void> _onLoadSavedCredentials(LoadSavedCredentials event, Emitter<LoginState> emit) async {
    try {
      final credentials = AuthService.loadSavedCredentials();
      emit(state.copyWith(
        status: LoginStatus.credentialsLoaded,
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

  Future<void> _reqLogIn(LoginSubmitted event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      _saveCredentialsIfRemembered();

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        final AuthModel response = await _authRepository.reqLogIn(
          email: event.email,
          password: event.password,
        );

        if (response.token != null) {
          _authRepository.requestHandler.updateHeader(token: response.token ?? "");
        }

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