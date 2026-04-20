import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repo/family_repo.dart';
import 'family_tree_event.dart';
import 'family_tree_state.dart';

class FamilyTreeBloc extends Bloc<FamilyTreeEvent, FamilyTreeState> {
  final FamilyRepository _repository = FamilyRepository();

  FamilyTreeBloc() : super(const FamilyTreeState()) {
    on<FetchFamilyTree>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFamilyTree event,
      Emitter<FamilyTreeState> emit,
      ) async {
    try {
      emit(state.copyWith(status: FamilyTreeStatus.loading));
      final result = await _repository.getFamilyTree();
      emit(state.copyWith(
        status: FamilyTreeStatus.success,
        familyMembers: result.familyMembers ?? [],
      ));
    } catch (e) {
      log('FamilyTreeBloc - Fetch error: $e');
      emit(state.copyWith(
        status: FamilyTreeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}