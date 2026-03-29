import 'package:equatable/equatable.dart';

abstract class BottomNavBarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BottomNavBarTabChanged extends BottomNavBarEvent {
  final int index;
  BottomNavBarTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}