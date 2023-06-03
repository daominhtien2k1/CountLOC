import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'post_event.dart';
import 'post_state.dart';


const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  late final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostState.initial()) {

    on<PostsReload>(
      _onPostsReload,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PostsFetched>(
      _onPostsFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PostLike>(_onPostLike);

    on<PostAdd>(_onPostAdd);

    on<PostReport>(_onPostReport);

    on<PostDelete>(_onPostDelete);

  }

  void _onPostsReload(PostsReload event, Emitter<PostState> emit) {
    try {
      return emit(
        state.copyWith(
          status: PostStatus.initial,
          postList: PostList.initial(),
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostsFetched(PostsFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final postListData = await postRepository.fetchPosts();
        // lọc tất cả các bài viết bị banned
        final mustFilteredPosts = postListData.posts;
        mustFilteredPosts.retainWhere((post) => post.banned == false && post.isBlocked == false);
        final postList = postListData.copyWith(posts: mustFilteredPosts);
        // print('Length: ${postList.posts.length}');
        emit(state.copyWith(status: PostStatus.loading));
        return emit(
          state.copyWith(
            status: PostStatus.success,
            postList: postList,
            hasReachedMax: false,
          ),
        );
      }
      final postListLength = state.postList.posts.length;
      final finalPost = state.postList.posts[postListLength-1] as Post; // đây là 1 cách khác lấy last_id
      final postListData = await postRepository.fetchPosts(startIndex: postListLength, last_id: state.postList.last_id);
      final mustFilteredPosts = postListData.posts;
      mustFilteredPosts.retainWhere((post) => post.banned == false && post.isBlocked == false);
      final postList = postListData.copyWith(posts: mustFilteredPosts);
      emit(state.copyWith(status: PostStatus.loading));
      if(postList.posts.isEmpty)
          emit(state.copyWith(status: PostStatus.success, hasReachedMax: true));
      else {
            state.postList.posts.addAll(postList.posts);
            state.postList.last_id = postList.last_id;
            emit(
              state.copyWith(
                status: PostStatus.success,
                postList: state.postList,
                hasReachedMax: false,
              )
            );
      }

    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  // không có cách nào show toast message mà không đọc state
  Future<void> _onPostLike(PostLike event, Emitter<PostState> emit) async {
    final mustUpdatePost = event.post;
    final posts = state.postList.posts as List<Post>;
    print("#PostBloc: when like in person screen: $posts");
    print("#PostBloc: when like in person screen: $mustUpdatePost");
    final indexOfMustUpdatePost = posts.indexOf(mustUpdatePost);
    print("#PostBloc: indexOfMustUpdatePost: $indexOfMustUpdatePost");
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

  Future<void> _onPostAdd(PostAdd event, Emitter<PostState> emit) async {
    final String described = event.described;
    final String? status = event.status;
    final List<XFile>? imageFileList = event.imageFileList;
    try {
      emit(state.copyWith(status: PostStatus.loading));
      final newPost = await postRepository.addPost(described: described, status: status, imageFileList: imageFileList);
      if (newPost != null){
        // final AttachedVideo? videoInPost;
        // if (newPost.video != null) {
        //   videoInPost = AttachedVideo(url: newPost.video!.url, publicId: newPost.video!.publicId);
        // } else {
        //   videoInPost = null;
        // }
        //
        // final newPostEmergence = Post(id: newPost.id, described: newPost.described, createdAt: newPost.createdAt,
        //     updatedAt: newPost.updatedAt, likes: newPost.likes, comments: newPost.comments,
        //     author: Author(id: newPost.author.id, name: newPost.author.name, avatar: newPost.author.avatar),
        //     isLiked: newPost.isLiked, isBlocked: newPost.isBlocked, canComment: newPost.canComment, canEdit: newPost.canEdit, banned: newPost.banned,
        //     status: newPost.status, video: videoInPost
        // );
        final newPostEmergence = Post.fromJson(newPost.toJson());
        state.postList.posts.insert(0, newPostEmergence);
        emit(
            state.copyWith(
              status: PostStatus.success,
              postList: state.postList
            )
        );
      }


    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostReport(PostReport event, Emitter<PostState> emit) async {
    final String postId = event.postId;
    final String subject = event.subject;
    final String details = event.details;
    try {
      await postRepository.reportPost(postId: postId, subject: subject, details: details);
    } catch (_) {

    }
  }

  Future<void> _onPostDelete(PostDelete event, Emitter<PostState> emit) async {
    final String postId = event.postId;
    try {
      final isDeleted = await postRepository.deletePost(postId: postId);
      if(isDeleted) {
        final posts = state.postList.posts as List<Post>;
        final indexOfMustDeletePost = posts.indexWhere((post) => post.id == postId);
        // print(indexOfMustDeletePost);
        // print(state.postList.posts.length);
        state.postList.posts.removeAt(indexOfMustDeletePost);
        // print(state.postList.posts.length); // đã xóa rồi mà
        // emit(state.copyWith(postList: state.postList)); // không được
        emit(state.copyWith(postList: PostList(posts: posts, new_items: state.postList.new_items, last_id: state.postList.last_id)));
      }
    } catch (_) {

    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('#POST OBSERVER: $error');
  }

  @override
  void onTransition(Transition<PostEvent, PostState> transition) {
    super.onTransition(transition);
    // print('#POST OBSERVER: $transition');
  }

  @override
  void onEvent(PostEvent event) {
    super.onEvent(event);
    print('#POST OBSERVER: $event');
  }

  @override
  void onChange(Change<PostState> change) {
    super.onChange(change);
    print('#POST OBSERVER: { stateCurrent: ${change.currentState.postList.posts.length}, last_idCurrent: ${change.currentState.postList.last_id}, statusCurrent: ${change.currentState.status}, hasReachedMaxCurrent: ${change.currentState.hasReachedMax} }');
    print('#POST OBSERVER: { stateNext: ${change.nextState.postList.posts.length}, last_idNext: ${change.nextState.postList.last_id}, statusNext: ${change.nextState.status}, hasReachedMaxCurrentNext: ${change.nextState.hasReachedMax}}');
  }
}