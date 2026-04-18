import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repo/family_repo.dart';
import 'family_name_event.dart';
import 'family_name_state.dart';

class FamilyNameBloc extends Bloc<FamilyNameEvent, FamilyNameState> {
  final FamilyRepository _repository = FamilyRepository();

  FamilyNameBloc() : super(const FamilyNameState()) {
    on<FetchFamilyNameList>(_onFetch);
    on<FamilyNameCreateSubmitted>(_onCreate);
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> _onFetch(
      FetchFamilyNameList event,
      Emitter<FamilyNameState> emit,
      ) async {
    try {
      emit(state.copyWith(status: FamilyNameStatus.loading));
      final result = await _repository.getAllFamilyName();
      emit(state.copyWith(
        status: FamilyNameStatus.success,
        families: result.families ?? [],
      ));
    } catch (e) {
      log('Fetch family name error: $e');
      emit(state.copyWith(
        status: FamilyNameStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────
  Future<void> _onCreate(
      FamilyNameCreateSubmitted event,
      Emitter<FamilyNameState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: FamilyNameMutationStatus.loading));
      await _repository.reqCreateFamilyName(
        familyName: event.familyName,
      );
      emit(state.copyWith(mutationStatus: FamilyNameMutationStatus.success));
      add(FetchFamilyNameList());
    } catch (e) {
      log('Create family name error: $e');
      emit(state.copyWith(
        mutationStatus: FamilyNameMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }
}