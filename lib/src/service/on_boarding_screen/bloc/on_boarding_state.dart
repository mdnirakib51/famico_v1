import 'package:equatable/equatable.dart';

enum OnBoardingStatus { initial, viewing, navigating }

class OnBoardingState extends Equatable {
  final OnBoardingStatus status;
  final int currentPageIndex;
  final bool isLastPage;
  final bool shouldAnimateToPage;

  const OnBoardingState({
    this.status = OnBoardingStatus.initial,
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.shouldAnimateToPage = false,
  });

  OnBoardingState copyWith({
    OnBoardingStatus? status,
    int? currentPageIndex,
    bool? isLastPage,
    bool? shouldAnimateToPage,
  }) {
    return OnBoardingState(
      status: status ?? this.status,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      shouldAnimateToPage: shouldAnimateToPage ?? this.shouldAnimateToPage,
    );
  }

  @override
  List<Object?> get props => [status, currentPageIndex, isLastPage, shouldAnimateToPage];
}