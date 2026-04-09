import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ── Fetch all addresses ───────────────────────────────────────────────────────
class FetchAddressList extends AddressEvent {}

// ── Create ────────────────────────────────────────────────────────────────────
class AddressCreateSubmitted extends AddressEvent {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String addressType;

  AddressCreateSubmitted({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.addressType,
  });

  @override
  List<Object?> get props => [street, city, state, zip, country, addressType];
}

// ── Edit ──────────────────────────────────────────────────────────────────────
class AddressEditSubmitted extends AddressEvent {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String addressType;

  AddressEditSubmitted({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.addressType,
  });

  @override
  List<Object?> get props => [id, street, city, state, zip, country, addressType];
}

// ── Delete ────────────────────────────────────────────────────────────────────
class AddressDeleteRequested extends AddressEvent {
  final String id; // String — matches Addresses.id (String?)
  AddressDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}