
import 'package:equatable/equatable.dart';

import '../../data/model/profile_model.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileModel? profileModel;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profileModel,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileModel? profileModel,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profileModel: profileModel ?? this.profileModel,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profileModel, errorMessage];
}
