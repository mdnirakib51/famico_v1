import 'package:equatable/equatable.dart';
import '../../data/model/family_member_model.dart';
import '../../data/model/relation_ship_model.dart';

enum MakeRelationshipStatus { initial, loading, success, failure }
enum MakeRelationshipMutationStatus { idle, loading, success, failure }

class MakeRelationshipState extends Equatable {
  final MakeRelationshipStatus status;
  final MakeRelationshipMutationStatus mutationStatus;

  // Dropdown data
  final List<Members> members;           // member_id & relative_id
  final List<Relationships> relations;   // relation_id (sibling/parent etc.)
  final List<Relationships> relationships; // relationship_id (direct/indirect etc.)

  final String? errorMessage;
  final String? mutationError;

  const MakeRelationshipState({
    this.status = MakeRelationshipStatus.initial,
    this.mutationStatus = MakeRelationshipMutationStatus.idle,
    this.members = const [],
    this.relations = const [],
    this.relationships = const [],
    this.errorMessage,
    this.mutationError,
  });

  MakeRelationshipState copyWith({
    MakeRelationshipStatus? status,
    MakeRelationshipMutationStatus? mutationStatus,
    List<Members>? members,
    List<Relationships>? relations,
    List<Relationships>? relationships,
    String? errorMessage,
    String? mutationError,
  }) {
    return MakeRelationshipState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      members: members ?? this.members,
      relations: relations ?? this.relations,
      relationships: relationships ?? this.relationships,
      errorMessage: errorMessage,
      mutationError: mutationError,
    );
  }

  @override
  List<Object?> get props => [
    status, mutationStatus,
    members, relations, relationships,
    errorMessage, mutationError,
  ];
}