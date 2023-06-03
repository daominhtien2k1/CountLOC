import '../../models/models.dart';

enum CommentStatus {initial, loading, success, failure }

class CommentState{
  CommentStatus commentStatus;
  List<Comment>? comments;

  CommentState({required this.commentStatus, this.comments});
  CommentState.initial(): commentStatus = CommentStatus.initial, comments = List<Comment>.empty(growable: true);

  CommentState copyWith({CommentStatus? commentStatus, List<Comment>? comments}) {
    return CommentState(
      commentStatus: commentStatus ?? this.commentStatus,
      comments: comments ?? this.comments
    );
  }

}