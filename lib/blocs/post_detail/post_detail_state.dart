import '../../models/models.dart';

enum PostDetailStatus {initial, loading, success, failure }

class PostDetailState{
  PostDetailStatus postDetailStatus;
  PostDetail? postDetail;

  PostDetailState({required this.postDetailStatus, this.postDetail});
  PostDetailState.initial(): postDetailStatus = PostDetailStatus.initial, postDetail = null;

  PostDetailState copyWith({PostDetailStatus? postDetailStatus, PostDetail? postDetail}) {
    return PostDetailState(
      postDetailStatus: postDetailStatus ?? this.postDetailStatus,
      postDetail: postDetail ?? this.postDetail
    );
  }

  @override
  String toString() {
    return {
      'postDetailStatus': postDetailStatus.toString(),
      'postDetail': postDetail.toString()
    }.toString();
  }
}