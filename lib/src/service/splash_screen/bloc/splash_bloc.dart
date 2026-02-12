import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import '../../../domain/local/preferences/local_storage.dart';
import '../../../domain/local/preferences/local_storage_keys.dart';
import '../../../initializer.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<CheckAppInitialization>(_onCheckAppInitialization);
    on<CheckForUpdate>(_onCheckForUpdate);
    on<NavigateToNextScreen>(_onNavigateToNextScreen);
  }

  Future<void> _onCheckAppInitialization(CheckAppInitialization event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));
    try {
      // Check for app update
      add(CheckForUpdate());

      // Wait for 3 seconds (splash delay)
      await Future.delayed(const Duration(seconds: 3));

      // Navigate to next screen
      add(NavigateToNextScreen());
    } catch (e) {
      emit(state.copyWith(
        status: SplashStatus.error,
      ));
    }
  }

  Future<void> _onCheckForUpdate(CheckForUpdate event, Emitter<SplashState> emit) async {
    try {
      log('Checking for Update');
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        log('Update available');
        emit(state.copyWith(updateAvailable: true));
        await _performUpdate();
      }
    } catch (e) {
      log('Update check error: ${e.toString()}');
    }
  }

  Future<void> _performUpdate() async {
    try {
      log('Updating');
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      log('Update error: ${e.toString()}');
    }
  }

  Future<void> _onNavigateToNextScreen(NavigateToNextScreen event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.checking));

    final String? token = locator<LocalStorage>().getString(key: StorageKeys.accessToken);
    final bool onBoardingCompleted = locator<LocalStorage>().getBool(key: StorageKeys.onBoardingCompleted);

    emit(state.copyWith(
      status: SplashStatus.navigating,
      token: token,
      onBoardingCompleted: onBoardingCompleted,
    ));
  }
}