
import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAppInitialization extends SplashEvent {}

class CheckForUpdate extends SplashEvent {}

class NavigateToNextScreen extends SplashEvent {}
