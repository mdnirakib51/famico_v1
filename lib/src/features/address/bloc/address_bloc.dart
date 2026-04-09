import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../data/address_repo.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _repository = AddressRepository();

  AddressBloc() : super(const AddressState()) {
    on<FetchAddressList>(_onFetch);
    on<AddressCreateSubmitted>(_onCreate);
    on<AddressEditSubmitted>(_onEdit);
    on<AddressDeleteRequested>(_onDelete);
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> _onFetch(
      FetchAddressList event,
      Emitter<AddressState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AddressStatus.loading));
      final result = await _repository.getAllAddress();
      emit(state.copyWith(
        status: AddressStatus.success,
        addresses: result.addresses ?? [],
      ));
    } catch (e) {
      log('Fetch address error: $e');
      emit(state.copyWith(
        status: AddressStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────
  Future<void> _onCreate(
      AddressCreateSubmitted event,
      Emitter<AddressState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: AddressMutationStatus.loading));
      await _repository.reqCreateAddress(
        street: event.street,
        city: event.city,
        state: event.state,
        zip: event.zip,
        country: event.country,
        addressType: event.addressType,
      );
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
      add(FetchAddressList());
    } catch (e) {
      log('Create address error: $e');
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }

  // ── Edit ───────────────────────────────────────────────────────────────────
  Future<void> _onEdit(
      AddressEditSubmitted event,
      Emitter<AddressState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: AddressMutationStatus.loading));
      await _repository.reqEditAddress(
        addressId: event.id,
        street: event.street,
        city: event.city,
        state: event.state,
        zip: event.zip,
        country: event.country,
        addressType: event.addressType,
      );
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
      add(FetchAddressList());
    } catch (e) {
      log('Edit address error: $e');
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  Future<void> _onDelete(
      AddressDeleteRequested event,
      Emitter<AddressState> emit,
      ) async {
    try {
      emit(state.copyWith(mutationStatus: AddressMutationStatus.loading));
      await _repository.reqRemoveAddress(addressId: event.id);
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
      add(FetchAddressList());
    } catch (e) {
      log('Delete address error: $e');
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        mutationError: e.toString(),
      ));
    }
  }
}