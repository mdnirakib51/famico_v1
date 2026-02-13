import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../../domain/local/preferences/local_storage.dart';
import '../../../domain/local/preferences/local_storage_keys.dart';
import '../../../initializer.dart';
import 'on_boarding_event.dart';
import 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final int totalPages = 3;
  Timer? _autoSlideTimer;

  OnBoardingBloc() : super(const OnBoardingState()) {
    on<PageChanged>(_onPageChanged);
    on<LanguageChanged>(_onLanguageChanged);
    on<GetStartedPressed>(_onGetStartedPressed);
    on<OnBoardingCompleted>(_onOnBoardingCompleted);
  }

  Future<void> _onPageChanged(PageChanged event, Emitter<OnBoardingState> emit) async {
    final bool isLast = event.pageIndex == totalPages - 1;

    emit(state.copyWith(
      currentPageIndex: event.pageIndex,
      isLastPage: isLast,
      status: OnBoardingStatus.viewing,
    ));
  }

  Future<void> _onLanguageChanged(LanguageChanged event, Emitter<OnBoardingState> emit) async{
    emit(state.copyWith(
      selectLanguage: event.language
    ));
  }

  Future<void> _onGetStartedPressed(GetStartedPressed event, Emitter<OnBoardingState> emit) async {
    try {
      log('Get Started button pressed');

      // Stop auto-slide
      _autoSlideTimer?.cancel();

      // Mark onboarding as completed in local storage
      locator<LocalStorage>().setBool(key: StorageKeys.onBoardingCompleted, value: true);

      // Trigger navigation
      add(OnBoardingCompleted());
    } catch (e) {
      log('Error completing onboarding: ${e.toString()}');
    }
  }

  Future<void> _onOnBoardingCompleted(OnBoardingCompleted event, Emitter<OnBoardingState> emit) async {
    emit(state.copyWith(status: OnBoardingStatus.navigating));
  }

}