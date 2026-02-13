import 'package:equatable/equatable.dart';

enum OnBoardingStatus { initial, viewing, navigating }

class OnBoardingState extends Equatable {
  final OnBoardingStatus status;
  final int currentPageIndex;
  final bool isLastPage;
  final String selectedLanguage;

  const OnBoardingState({
    this.status = OnBoardingStatus.initial,
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.selectedLanguage = 'EN',
  });

  OnBoardingState copyWith({
    OnBoardingStatus? status,
    int? currentPageIndex,
    bool? isLastPage,
    String? selectLanguage,
  }) {
    return OnBoardingState(
      status: status ?? this.status,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      selectedLanguage: selectLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [status, currentPageIndex, isLastPage, selectedLanguage];
}