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
    on<GetStartedPressed>(_onGetStartedPressed);
    on<OnBoardingCompleted>(_onOnBoardingCompleted);
    on<StartAutoSlide>(_onStartAutoSlide);
    on<StopAutoSlide>(_onStopAutoSlide);
    on<AutoSlideNext>(_onAutoSlideNext);

    // Start auto-slide when bloc is created
    add(StartAutoSlide());
  }

  Future<void> _onPageChanged(PageChanged event, Emitter<OnBoardingState> emit) async {
    final bool isLast = event.pageIndex == totalPages - 1;

    emit(state.copyWith(
      currentPageIndex: event.pageIndex,
      isLastPage: isLast,
      status: OnBoardingStatus.viewing,
      shouldAnimateToPage: false,
    ));
  }

  Future<void> _onStartAutoSlide(StartAutoSlide event, Emitter<OnBoardingState> emit) async {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      add(AutoSlideNext());
    });
  }

  Future<void> _onStopAutoSlide(StopAutoSlide event, Emitter<OnBoardingState> emit) async {
    _autoSlideTimer?.cancel();
  }

  Future<void> _onAutoSlideNext(AutoSlideNext event, Emitter<OnBoardingState> emit) async {
    int nextPage = (state.currentPageIndex + 1) % totalPages;
    emit(state.copyWith(
      currentPageIndex: nextPage,
      isLastPage: nextPage == totalPages - 1,
      status: OnBoardingStatus.viewing,
      shouldAnimateToPage: true, // Animate for auto-slide
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

  @override
  Future<void> close() {
    _autoSlideTimer?.cancel();
    return super.close();
  }
}