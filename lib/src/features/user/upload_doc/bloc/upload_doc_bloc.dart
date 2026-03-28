import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import 'upload_doc_event.dart';
import 'upload_doc_state.dart';

class UploadDocBloc extends Bloc<UploadDocEvent, UploadDocState> {
  final UserRepository _userRepository = UserRepository();

  UploadDocBloc() : super(const UploadDocState()) {
    on<UploadDocImagePicked>(_onImagePicked);
    on<UploadDocNidPicked>(_onNidPicked);
    on<UploadDocSubmitted>(_onSubmit);
  }

  void _onImagePicked(UploadDocImagePicked event, Emitter<UploadDocState> emit) {
    emit(state.copyWith(image: event.image));
  }

  void _onNidPicked(UploadDocNidPicked event, Emitter<UploadDocState> emit) {
    emit(state.copyWith(nid: event.nid));
  }

  Future<void> _onSubmit(UploadDocSubmitted event, Emitter<UploadDocState> emit) async {
    if (state.image == null && state.nid == null) {
      emit(state.copyWith(
        status: UploadDocStatus.failure,
        errorMessage: 'Please select at least one file to upload',
      ));
      return;
    }

    try {
      emit(state.copyWith(status: UploadDocStatus.loading));

      await _userRepository.reqUploadDoc(
        imagePath: state.image,
        nidPath: state.nid,
      );

      emit(state.copyWith(status: UploadDocStatus.success));
    } catch (e) {
      log('Upload doc error: ${e.toString()}');
      emit(state.copyWith(
        status: UploadDocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}