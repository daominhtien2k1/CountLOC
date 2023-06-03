import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  late final CommentRepository commentRepository;

  CommentBloc(): super(CommentState.initial()) {
    commentRepository = CommentRepository();

    on<CommentFetched>(_onCommentFetched);
    on<CommentSet>(_onCommentSet);
  }

  Future<void> _onCommentFetched(CommentFetched event, Emitter<CommentState> emit) async {
    try {
      final postId = event.postId;
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      final List<Comment>? comments = await commentRepository.fetchComments(postId: postId);
      if (comments != null) {
        emit(CommentState(commentStatus: CommentStatus.success, comments: comments));
      }
    } catch(error) {
      emit(state.copyWith(commentStatus: CommentStatus.failure));
    }
  }

  Future<void> _onCommentSet(CommentSet event, Emitter<CommentState> emit) async {
    final postId = event.postId;
    final comment = event.comment;
    emit(state.copyWith(commentStatus: CommentStatus.loading));
    try {
      final List<Comment>? comments = await commentRepository.setComment(postId: postId, comment: comment);
      if (comments != null) {
        emit(CommentState(commentStatus: CommentStatus.success, comments: comments));
      } else {
        // để tạm, gửi comment hỏng nhưng vẫn giữ lại các comment khác
        emit(state.copyWith(commentStatus: CommentStatus.success));
      }
    } catch(error) {
      emit(state.copyWith(commentStatus: CommentStatus.failure));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#COMMENT OBSERVER: $error');
  }

  @override
  void onTransition(Transition<CommentEvent, CommentState> transition) {
    super.onTransition(transition);
    // print('#COMMENT OBSERVER: $transition');
  }

  @override
  void onEvent(CommentEvent event) {
    super.onEvent(event);
    // print('#COMMENT OBSERVER: $event');
  }

  @override
  void onChange(Change<CommentState> change) {
    super.onChange(change);
    // print('#COMMENT OBSERVER: { stateCurrent: ${change.currentState.comments?.length ?? 0}, statusCurrent: ${change.currentState.commentStatus} }');
    // print('#COMMENT OBSERVER: { stateNext: ${change.nextState.comments?.length ?? 0}, statusNext: ${change.nextState.commentStatus} }');
  }
}