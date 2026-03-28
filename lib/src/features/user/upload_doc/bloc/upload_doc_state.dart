import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum UploadDocStatus { initial, loading, success, failure }

class UploadDocState extends Equatable {
  final UploadDocStatus status;
  final XFile? image;
  final XFile? nid;
  final String? errorMessage;

  const UploadDocState({
    this.status = UploadDocStatus.initial,
    this.image,
    this.nid,
    this.errorMessage,
  });

  UploadDocState copyWith({
    UploadDocStatus? status,
    XFile? image,
    XFile? nid,
    String? errorMessage,
    bool clearImage = false,
    bool clearNid = false,
  }) {
    return UploadDocState(
      status: status ?? this.status,
      image: clearImage ? null : image ?? this.image,
      nid: clearNid ? null : nid ?? this.nid,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, image?.path, nid?.path, errorMessage];
}