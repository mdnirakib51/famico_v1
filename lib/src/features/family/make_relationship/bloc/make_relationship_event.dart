import 'package:equatable/equatable.dart';

abstract class MakeRelationshipEvent extends Equatable {
  const MakeRelationshipEvent();

  @override
  List<Object?> get props => [];
}

class FetchRelationshipFormData extends MakeRelationshipEvent {
  final int familyId;
  const FetchRelationshipFormData({required this.familyId});

  @override
  List<Object?> get props => [familyId];
}

class MakeRelationshipSubmitted extends MakeRelationshipEvent {
  final int familyId;
  final int memberId;
  final int relativeId;
  final int relationId;
  final int relationshipId;

  const MakeRelationshipSubmitted({
    required this.familyId,
    required this.memberId,
    required this.relativeId,
    required this.relationId,
    required this.relationshipId,
  });

  @override
  List<Object?> get props =>
      [familyId, memberId, relativeId, relationId, relationshipId];
}