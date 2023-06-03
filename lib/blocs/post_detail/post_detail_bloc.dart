import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'post_detail_event.dart';
import 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  late final PostRepository postRepository;
  PostDetailBloc({required this.postRepository}): super(PostDetailState.initial()) {
    on<PostDetailFetched>(_onPostDetailFetched);

    on<PostDetailLike>(_onPostDetailLike);
  }

  Future<void> _onPostDetailFetched(PostDetailFetched event, Emitter<PostDetailState> emit) async {
    try {
      final postId = event.postId;
      emit(PostDetailState(postDetailStatus: PostDetailStatus.loading));
      final postDetail = await postRepository.fetchDetailPost(postId: postId);
      if (postDetail != null) {
        emit(PostDetailState(postDetailStatus: PostDetailStatus.success, postDetail: postDetail));
      }

    } catch(error) {
      emit(PostDetailState(postDetailStatus: PostDetailStatus.failure, postDetail: null));
    }
  }

  Future<void> _onPostDetailLike(PostDetailLike event, Emitter<PostDetailState> emit) async {
    final postId = event.postId ;

    final mustUpdatePost = state.postDetail as PostDetail;
    int likes = mustUpdatePost.isLiked ? mustUpdatePost.likes - 1 : mustUpdatePost.likes + 1;
    final newUpdatedPost = mustUpdatePost.copyWith(likes: likes, isLiked: !mustUpdatePost.isLiked);

    emit(state.copyWith(postDetail: newUpdatedPost));

    try {
      if (!mustUpdatePost.isLiked){
        final likePost = await postRepository.likeHomePost(id: postId);
        if (likePost.code == '506') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì không like được
        } else if (likePost.code == '9991') {
          // nếu like phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI

        }
      }
      if(mustUpdatePost.isLiked) {
        final unlikePost = await postRepository.unlikeHomePost(id: postId);
        if (unlikePost.code == '507') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì vẫn unlike được ----> không tồn tại TC2
        } else if (unlikePost.code == '9991') {
          // nếu unlike phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI

        }
      }

    } catch(error) {

    }
  }
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#POST_DETAIL OBSERVER: $error');
  }

  @override
  void onTransition(Transition<PostDetailEvent, PostDetailState> transition) {
    super.onTransition(transition);
    // print('#POST_DETAIL OBSERVER: $transition');
  }

  @override
  void onEvent(PostDetailEvent event) {
    super.onEvent(event);
    // print('#POST_DETAIL OBSERVER: $event');
  }

  @override
  void onChange(Change<PostDetailState> change) {
    super.onChange(change);
    // print('#POST_DETAIL OBSERVER: ${change.currentState} ---> ${change.nextState}' );
  }
}