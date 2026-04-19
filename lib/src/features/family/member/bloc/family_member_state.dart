import 'package:equatable/equatable.dart';
import '../../data/model/family_member_model.dart';

enum FamilyMemberStatus { initial, loading, success, failure }
enum FamilyMemberMutationStatus { idle, loading, success, failure }

class FamilyMemberState extends Equatable {
  final FamilyMemberStatus status;
  final FamilyMemberMutationStatus mutationStatus;
  final List<Members> members;
  final String? errorMessage;
  final String? mutationError;

  const FamilyMemberState({
    this.status = FamilyMemberStatus.initial,
    this.mutationStatus = FamilyMemberMutationStatus.idle,
    this.members = const [],
    this.errorMessage,
    this.mutationError,
  });

  FamilyMemberState copyWith({
    FamilyMemberStatus? status,
    FamilyMemberMutationStatus? mutationStatus,
    List<Members>? members,
    String? errorMessage,
    String? mutationError,
  }) {
    return FamilyMemberState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      members: members ?? this.members,
      errorMessage: errorMessage,
      mutationError: mutationError,
    );
  }

  @override
  List<Object?> get props =>
      [status, mutationStatus, members, errorMessage, mutationError];
}