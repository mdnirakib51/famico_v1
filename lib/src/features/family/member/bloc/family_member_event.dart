import 'package:equatable/equatable.dart';

abstract class FamilyMemberEvent extends Equatable {
  const FamilyMemberEvent();

  @override
  List<Object?> get props => [];
}

class FetchFamilyMemberList extends FamilyMemberEvent {
  const FetchFamilyMemberList();
}

class FamilyMemberCreateSubmitted extends FamilyMemberEvent {
  final int familyId;
  final String name;
  final String dob;
  final String phone;
  final String? email;
  final String? status;
  // Present Address
  final String presentStreet;
  final String presentCity;
  final String presentState;
  final String presentZip;
  final String presentCountry;
  // Permanent Address
  final String permanentStreet;
  final String permanentCity;
  final String permanentState;
  final String permanentZip;
  final String permanentCountry;

  const FamilyMemberCreateSubmitted({
    required this.familyId,
    required this.name,
    required this.dob,
    required this.phone,
    this.email,
    this.status,
    required this.presentStreet,
    required this.presentCity,
    required this.presentState,
    required this.presentZip,
    required this.presentCountry,
    required this.permanentStreet,
    required this.permanentCity,
    required this.permanentState,
    required this.permanentZip,
    required this.permanentCountry,
  });

  @override
  List<Object?> get props => [
    familyId, name, dob, phone, email, status,
    presentStreet, presentCity, presentState, presentZip, presentCountry,
    permanentStreet, permanentCity, permanentState, permanentZip, permanentCountry,
  ];
}