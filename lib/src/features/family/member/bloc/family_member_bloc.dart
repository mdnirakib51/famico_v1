import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repo/family_repo.dart';
import 'family_member_event.dart';
import 'family_member_state.dart';

class FamilyMemberBloc extends Bloc<FamilyMemberEvent, FamilyMemberState> {
  final FamilyRepository _repository = FamilyRepository();

  FamilyMemberBloc() : super(const FamilyMemberState()) {
    on<FetchFamilyMemberList>(_onFetch);
    on<FamilyMemberCreateSubmitted>(_onCreate);
  }

  Future<void> _onFetch(
      FetchFamilyMemberList event,
      Emitter<FamilyMemberState> emit,
      ) async {
    try {
      emit(state.copyWith(status: FamilyMemberStatus.loading));
      final result = await _repository.getFamilyMember();
      emit(state.copyWith(
        status: FamilyMemberStatus.success,
        members: result.members ?? [],
      ));
    } catch (e) {
      log('FamilyMemberBloc - Fetch error: $e');
      emit(state.copyWith(
        status: FamilyMemberStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreate(
      FamilyMemberCreateSubmitted event,
      Emitter<FamilyMemberState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: FamilyMemberMutationStatus.loading));

      await _repository.reqCreateFamilyMember(
        familyId: event.familyId,
        name: event.name,
        dob: event.dob,
        phone: event.phone,
        email: event.email,
        status: event.status,
        presentStreet: event.presentStreet,
        presentCity: event.presentCity,
        presentState: event.presentState,
        presentZip: event.presentZip,
        presentCountry: event.presentCountry,
        permanentStreet: event.permanentStreet,
        permanentCity: event.permanentCity,
        permanentState: event.permanentState,
        permanentZip: event.permanentZip,
        permanentCountry: event.permanentCountry,
      );

      emit(state.copyWith(mutationStatus: FamilyMemberMutationStatus.success));
      add(const FetchFamilyMemberList());
    } catch (e) {
      log('FamilyMemberBloc - Create error: $e');
      emit(state.copyWith(
        mutationStatus: FamilyMemberMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }
}