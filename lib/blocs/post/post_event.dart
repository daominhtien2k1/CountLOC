import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostsFetched extends PostEvent {}

class PostsReload extends PostEvent {}

class PostLike extends PostEvent {
  final Post post;
  PostLike({required this.post});
}

class PostAdd extends PostEvent {
  final String described;
  final String? status;
  final List<XFile>? imageFileList;
  PostAdd({required this.described, this.status, this.imageFileList});
}

class PostReport extends PostEvent {
  final String postId;
  final String subject;
  final String details;
  PostReport({required this.postId, required this.subject, required this.details});
}

class PostDelete extends PostEvent {
  final String postId;
  PostDelete({required this.postId});
}