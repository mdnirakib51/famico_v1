import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadDocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadDocImagePicked extends UploadDocEvent {
  final XFile image;
  UploadDocImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class UploadDocNidPicked extends UploadDocEvent {
  final XFile nid;
  UploadDocNidPicked(this.nid);

  @override
  List<Object?> get props => [nid];
}

class UploadDocSubmitted extends UploadDocEvent {}