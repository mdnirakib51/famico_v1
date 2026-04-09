import 'package:equatable/equatable.dart';
import '../data/model/address_list_model.dart';

enum AddressStatus { initial, loading, success, failure }
enum AddressMutationStatus { idle, loading, success, failure }

class AddressState extends Equatable {
  final AddressStatus status;
  final AddressMutationStatus mutationStatus;
  final List<Addresses> addresses; // ← Addresses (not Address)
  final String? errorMessage;
  final String? mutationError;

  const AddressState({
    this.status = AddressStatus.initial,
    this.mutationStatus = AddressMutationStatus.idle,
    this.addresses = const [],
    this.errorMessage,
    this.mutationError,
  });

  AddressState copyWith({
    AddressStatus? status,
    AddressMutationStatus? mutationStatus,
    List<Addresses>? addresses,
    String? errorMessage,
    String? mutationError,
  }) {
    return AddressState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
      mutationError: mutationError,
    );
  }

  @override
  List<Object?> get props =>
      [status, mutationStatus, addresses, errorMessage, mutationError];
}