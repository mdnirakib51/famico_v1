import 'package:equatable/equatable.dart';

abstract class OnBoardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PageChanged extends OnBoardingEvent {
  final int pageIndex;

  PageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

class GetStartedPressed extends OnBoardingEvent {}

class OnBoardingCompleted extends OnBoardingEvent {}

class StartAutoSlide extends OnBoardingEvent {}

class StopAutoSlide extends OnBoardingEvent {}

class AutoSlideNext extends OnBoardingEvent {}