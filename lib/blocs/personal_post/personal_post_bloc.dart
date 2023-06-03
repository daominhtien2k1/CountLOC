import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'personal_post_event.dart';
import 'personal_post_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PersonalPostBloc extends Bloc<PersonalPostEvent, PersonalPostState> {
  final PostRepository postRepository;

  PersonalPostBloc({required this.postRepository}) : super(PersonalPostState.initial()) {

    on<PersonalPostReload>(
      _onPostReload,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PersonalPostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PersonalPostLike>(_onLikePost);
  }

  void _onPostReload(PersonalPostReload event, Emitter<PersonalPostState> emit) {
    try {
      return emit(
        state.copyWith(
          status: PersonalPostStatus.initial,
          postList: PostList.initial(),
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PersonalPostStatus.failure));
    }
  }

  Future<void> _onPostFetched(PersonalPostFetched event, Emitter<PersonalPostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PersonalPostStatus.initial) {
        final postListData = await postRepository.fetchPostsByAccountId(accountId: event.accountId);
        // lọc tất cả các bài viết bị banned
        final mustFilteredPosts = postListData.posts;
        mustFilteredPosts.retainWhere((post) => post.banned == false && post.isBlocked == false);
        final postList = postListData.copyWith(posts: mustFilteredPosts);
        // print('Length: ${postList.posts.length}');
        emit(state.copyWith(status: PersonalPostStatus.loading));
        return emit(
          state.copyWith(
            status: PersonalPostStatus.success,
            postList: postList,
            hasReachedMax: false,
          ),
        );
      }
      final postListLength = state.postList.posts.length;
      final finalPost = state.postList.posts[postListLength-1] as Post; // đây là 1 cách khác lấy last_id
      final postListData = await postRepository.fetchPostsByAccountId(accountId: event.accountId, startIndex: postListLength, last_id: state.postList.last_id);
      final mustFilteredPosts = postListData.posts;
      mustFilteredPosts.retainWhere((post) => post.banned == false && post.isBlocked == false);
      final postList = postListData.copyWith(posts: mustFilteredPosts);
      emit(state.copyWith(status: PersonalPostStatus.loading));
      if(postList.posts.isEmpty)
        emit(state.copyWith(status: PersonalPostStatus.success, hasReachedMax: true));
      else {
        state.postList.posts.addAll(postList.posts);
        state.postList.last_id = postList.last_id;
        emit(
            state.copyWith(
              status: PersonalPostStatus.success,
              postList: state.postList,
              hasReachedMax: false,
            )
        );
      }

    } catch (_) {
      emit(state.copyWith(status: PersonalPostStatus.failure));
    }
  }

  // không có cách nào show toast message mà không đọc state
  Future<void> _onLikePost(PersonalPostLike event, Emitter<PersonalPostState> emit) async {
    final mustUpdatePost = event.post;
    final posts = state.postList.posts as List<Post>;
    // lí do một trong 2 cái là -1 là: 1. updatedAt thay đổi, 2. likes thay đổi ---> logic phức tạp --> tạm thời chấp nhận
    print("#PersonalPostBloc: when like in home screen: $posts");
    print("#PersonalPostBloc: when like in home screen: $mustUpdatePost");
    final indexOfMustUpdatePost = posts.indexOf(mustUpdatePost);
    print("#PersonalPostBloc: indexOfMustUpdatePost: $indexOfMustUpdatePost");
    if(indexOfMustUpdatePost == -1) return;

    int likes = mustUpdatePost.isLiked ? mustUpdatePost.likes - 1 : mustUpdatePost.likes + 1;
    final newUpdatedPost = mustUpdatePost.copyWith(likes: likes, isLiked: !mustUpdatePost.isLiked);
    posts..remove(mustUpdatePost)..insert(indexOfMustUpdatePost, newUpdatedPost);
    // emit(state.copyWith(postList: state.postList)); // RangeError: Invalid value: Not in inclusive range 0..5: -1
    /*
       Về lý thuyết, khi thay đổi trạng thái 1 post, thì chỉ post đó được render chứ không phải whole list.
       Nhưng hiện tại, đang làm là tạo 1 PostList mới hoàn toàn, nhưng Flutter chỉ render toàn bộ Post (3-4) nằm trong vùng visible scroll view -> tạm chấp nhận được
    */
    emit(state.copyWith(postList: PostList(posts: posts, new_items: state.postList.new_items, last_id: state.postList.last_id)));
    try {
      if (!mustUpdatePost.isLiked){
        final likePost = await postRepository.likeHomePost(id: mustUpdatePost.id);
        if (likePost.code == '1009') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì không like được
          if (likePost.message == 'Người viết đã chặn bạn / Bạn chặn người viết, do đó không thể like bài viết') {
            posts.remove(newUpdatedPost);
            emit(state.copyWith(postList: PostList(posts: posts, new_items: state.postList.new_items, last_id: state.postList.last_id)));
          }
        } else if (likePost.code == '9991') {
          // nếu like phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI
          posts.remove(newUpdatedPost);
          emit(state.copyWith(postList: PostList(posts: posts, new_items: state.postList.new_items, last_id: state.postList.last_id)));
        }
      }
      if(mustUpdatePost.isLiked) {
        final unlikePost = await postRepository.unlikeHomePost(id: mustUpdatePost.id);
        if (unlikePost.code == '1009') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì vẫn unlike được ----> không tồn tại TC2
        } else if (unlikePost.code == '9991') {
          // nếu unlike phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI
          posts.remove(newUpdatedPost);
          emit(state.copyWith(postList: PostList(posts: posts, new_items: state.postList.new_items, last_id: state.postList.last_id)));
        }
      }

    } catch(error) {

    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('#PERSONAL POST OBSERVER: $error');
  }

  @override
  void onTransition(Transition<PersonalPostEvent, PersonalPostState> transition) {
    super.onTransition(transition);
    // print('#PERSONAL POST OBSERVER: $transition');
  }

  @override
  void onEvent(PersonalPostEvent event) {
    super.onEvent(event);
    print('#PERSONAL POST OBSERVER: $event');
  }

  @override
  void onChange(Change<PersonalPostState> change) {
    super.onChange(change);
    print('#PERSONAL POST OBSERVER: { stateCurrent: ${change.currentState.postList.posts.length}, last_idCurrent: ${change.currentState.postList.last_id}, statusCurrent: ${change.currentState.status}, hasReachedMaxCurrent: ${change.currentState.hasReachedMax} }');
    print('#PERSONAL POST OBSERVER: { stateNext: ${change.nextState.postList.posts.length}, last_idNext: ${change.nextState.postList.last_id}, statusNext: ${change.nextState.status}, hasReachedMaxCurrentNext: ${change.nextState.hasReachedMax}}');
  }
}