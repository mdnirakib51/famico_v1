import 'package:equatable/equatable.dart';
import '../../data/model/family_tree_model.dart';

enum FamilyTreeStatus { initial, loading, success, failure }

class FamilyTreeState extends Equatable {
  final FamilyTreeStatus status;
  final List<FamilyMembers> familyMembers;
  final String? errorMessage;

  const FamilyTreeState({
    this.status = FamilyTreeStatus.initial,
    this.familyMembers = const [],
    this.errorMessage,
  });

  FamilyTreeState copyWith({
    FamilyTreeStatus? status,
    List<FamilyMembers>? familyMembers,
    String? errorMessage,
  }) {
    return FamilyTreeState(
      status: status ?? this.status,
      familyMembers: familyMembers ?? this.familyMembers,
      errorMessage: errorMessage,
    );
  }

  /// Blood Related members আলাদা করা
  List<FamilyMembers> get bloodRelatedMembers => familyMembers.where((m) => m.relationships
      ?.any((r) => r.relationshipTypes?.relationship == 'Blood Related') ?? false).toList();

  /// Close Relatives members আলাদা করা
  List<FamilyMembers> get closeRelativeMembers => familyMembers.where((m) => m.relationships
      ?.any((r) => r.relationshipTypes?.relationship == 'Close Relatives') ?? false).toList();

  /// কোনো relationship নেই এমন members
  List<FamilyMembers> get unlinkedMembers => familyMembers
      .where((m) => m.relationships == null || m.relationships!.isEmpty)
      .toList();

  @override
  List<Object?> get props => [status, familyMembers, errorMessage];
}