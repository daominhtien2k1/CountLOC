import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../repositories/repositories.dart';
import '../../models/models.dart';
import 'list_video_event.dart';
import 'list_video_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ListVideoBloc extends Bloc<ListVideoEvent, ListVideoState> {
  late final VideoRepository videoRepository;

  ListVideoBloc({required this.videoRepository}) : super(ListVideoState.initial()) {
    on<ListVideoReload>(
      _onListVideoReload,
      transformer: throttleDroppable(throttleDuration),
    );

    on<ListVideoFetched>(
      _onListVideoFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<VideoPostLike>(_onLikeVideoPost);
  }

  void _onListVideoReload(ListVideoReload event, Emitter<ListVideoState> emit) {
    try {
      return emit(
        state.copyWith(
          status: ListVideoStatus.initial,
          videoList: VideoList.initial()
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ListVideoStatus.failure));
    }
  }

  Future<void> _onListVideoFetched(ListVideoFetched event, Emitter<ListVideoState> emit) async {
    try {
      if (state.status == ListVideoStatus.initial) {
        final videoListData = await videoRepository.getListVideo();
        emit(state.copyWith(status: ListVideoStatus.loading));
        return emit(
          state.copyWith(
            status: ListVideoStatus.success,
            videoList: videoListData
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: ListVideoStatus.failure));
    }
  }

  Future<void> _onLikeVideoPost(VideoPostLike event, Emitter<ListVideoState> emit) async {
    final mustUpdatePost = event.video as VideoElement;
    final videos = state.videoList.videos as List<VideoElement>;
    final indexOfMustUpdatePost = videos.indexOf(mustUpdatePost);
    int likes = mustUpdatePost.isLiked ? mustUpdatePost.likes - 1 : mustUpdatePost.likes + 1;
    final newUpdatedPost = mustUpdatePost.copyWith(likes: likes, isLiked: !mustUpdatePost.isLiked);
    videos..remove(mustUpdatePost)..insert(indexOfMustUpdatePost, newUpdatedPost);

    emit(state.copyWith(videoList: VideoList(videos: videos)));

    try {
      if (!mustUpdatePost.isLiked){
        final likeVideo = await videoRepository.likeVideo(id: mustUpdatePost.id);
        if (likeVideo.code == '506') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì không like được
        } else if (likeVideo.code == '9991') {
          // nếu like phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI

        }
      }
      if(mustUpdatePost.isLiked) {
        final unlikeVideo = await videoRepository.unlikeVideo(id: mustUpdatePost.id);
        if (unlikeVideo.code == '507') {
          // TC1: tài khoản của mình đột nhiên bị khóa, cần chuyển tới màn login ---> Không làm được, do không gọi tới AuthBloc mà update state
          // TC2: Nếu mình block nó/nó block mình thì vẫn unlike được ----> không tồn tại TC2
        } else if (unlikeVideo.code == '9991') {
          // nếu unlike phải bài viết bị banned, lúc này mình chưa ấn reload ứng dụng nên chưa get lại API lọc posts nên sẽ xóa bài viết khỏi UI

        }
      }

    } catch(error) {

    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#VIDEO OBSERVER: $error');
  }

  @override
  void onTransition(Transition<ListVideoEvent, ListVideoState> transition) {
    super.onTransition(transition);
    // print('#POST OBSERVER: $transition');
  }

  @override
  void onEvent(ListVideoEvent event) {
    super.onEvent(event);
    // print('#VIDEO OBSERVER: $event');
  }

  @override
  void onChange(Change<ListVideoState> change) {
    super.onChange(change);
    // print('#VIDEO OBSERVER: { stateCurrent: ${change.currentState.videoList.videos.length}, statusCurrent: ${change.currentState.status} }');
    // print('#VIDEO OBSERVER: { stateNext: ${change.nextState.videoList.videos.length}, statusNext: ${change.nextState.status}}');
  }
}
