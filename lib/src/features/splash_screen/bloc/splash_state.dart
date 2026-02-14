
import 'package:equatable/equatable.dart';

enum SplashStatus { initial, loading, checking, navigating, error }

class SplashState extends Equatable {
  final SplashStatus status;
  final bool updateAvailable;
  final String? token;
  final bool onBoardingCompleted;

  const SplashState({
    this.status = SplashStatus.initial,
    this.updateAvailable = false,
    this.token,
    this.onBoardingCompleted = false,
  });

  SplashState copyWith({
    SplashStatus? status,
    bool? updateAvailable,
    String? token,
    bool? onBoardingCompleted,
  }) {
    return SplashState(
      status: status ?? this.status,
      updateAvailable: updateAvailable ?? this.updateAvailable,
      token: token ?? this.token,
      onBoardingCompleted: onBoardingCompleted ?? this.onBoardingCompleted,
    );
  }

  @override
  List<Object?> get props => [status, updateAvailable, token, onBoardingCompleted];
}
