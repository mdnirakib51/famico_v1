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

class LanguageChanged extends OnBoardingEvent{
  final String language;

  LanguageChanged(this.language);

  @override
  List<Object?> get props => [language];
}

class GetStartedPressed extends OnBoardingEvent {}

class OnBoardingCompleted extends OnBoardingEvent {}