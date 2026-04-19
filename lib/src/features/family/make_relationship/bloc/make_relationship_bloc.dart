
import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repo/family_repo.dart';
import 'make_relationship_event.dart';
import 'make_relationship_state.dart';

class MakeRelationshipBloc extends Bloc<MakeRelationshipEvent, MakeRelationshipState> {
  final FamilyRepository _repository = FamilyRepository();

  MakeRelationshipBloc() : super(const MakeRelationshipState()) {
    on<FetchRelationshipFormData>(_onFetch);
    on<MakeRelationshipSubmitted>(_onSubmit);
  }

  // ── Fetch members + relation types + relation natures ─────────────────────
  Future<void> _onFetch(
      FetchRelationshipFormData event,
      Emitter<MakeRelationshipState> emit,
      ) async {
    try {
      emit(state.copyWith(status: MakeRelationshipStatus.loading));

      // 3টা API parallel এ call
      final results = await Future.wait([
        _repository.getFamilyMember(familyId: event.familyId),
        _repository.getRelationShip(),
        _repository.getRelation(),
      ]);

      final memberResult = results[0] as dynamic;
      final relationShipResult = results[1] as dynamic;
      final relationResult = results[2] as dynamic;

      emit(state.copyWith(
        status: MakeRelationshipStatus.success,
        members: memberResult.members ?? [],
        relations: relationShipResult.relationships ?? [],
        relationships: relationResult.relationships ?? [],
      ));
    } catch (e) {
      log('MakeRelationshipBloc - Fetch error: $e');
      emit(state.copyWith(
        status: MakeRelationshipStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _onSubmit(
      MakeRelationshipSubmitted event,
      Emitter<MakeRelationshipState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: MakeRelationshipMutationStatus.loading));

      await _repository.reqMakeRelationship(
        familyId: event.familyId,
        memberId: event.memberId,
        relativeId: event.relativeId,
        relationId: event.relationId,
        relationshipId: event.relationshipId,
      );

      emit(state.copyWith(
          mutationStatus: MakeRelationshipMutationStatus.success));
    } catch (e) {
      log('MakeRelationshipBloc - Submit error: $e');
      emit(state.copyWith(
        mutationStatus: MakeRelationshipMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }
}