import 'package:equatable/equatable.dart';
import '../../data/model/family_name_model.dart';

enum FamilyNameStatus { initial, loading, success, failure }
enum FamilyNameMutationStatus { idle, loading, success, failure }

class FamilyNameState extends Equatable {
  final FamilyNameStatus status;
  final FamilyNameMutationStatus mutationStatus;
  final List<Families> families;
  final String? errorMessage;
  final String? mutationError;

  const FamilyNameState({
    this.status = FamilyNameStatus.initial,
    this.mutationStatus = FamilyNameMutationStatus.idle,
    this.families = const [],
    this.errorMessage,
    this.mutationError,
  });

  FamilyNameState copyWith({
    FamilyNameStatus? status,
    FamilyNameMutationStatus? mutationStatus,
    List<Families>? families,
    String? errorMessage,
    String? mutationError,
  }) {
    return FamilyNameState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      families: families ?? this.families,
      errorMessage: errorMessage,
      mutationError: mutationError,
    );
  }

  @override
  List<Object?> get props =>
      [status, mutationStatus, families, errorMessage, mutationError];
}