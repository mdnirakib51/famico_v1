import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository = UserRepository();

  ProfileBloc() : super(const ProfileState()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final response = await _userRepository.getUserProfile();

      emit(state.copyWith(status: ProfileStatus.success, profileModel: response));
    } catch (e) {
      log('Profile fetch error: ${e.toString()}');
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}