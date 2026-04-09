import 'package:equatable/equatable.dart';

abstract class FamilyNameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFamilyNameList extends FamilyNameEvent {}

class FamilyNameCreateSubmitted extends FamilyNameEvent {
  final String familyName;

  FamilyNameCreateSubmitted({required this.familyName});

  @override
  List<Object?> get props => [familyName];
}