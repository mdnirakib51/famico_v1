import 'package:equatable/equatable.dart';

abstract class FamilyTreeEvent extends Equatable {
  const FamilyTreeEvent();
  @override
  List<Object?> get props => [];
}

class FetchFamilyTree extends FamilyTreeEvent {
  const FetchFamilyTree();
}