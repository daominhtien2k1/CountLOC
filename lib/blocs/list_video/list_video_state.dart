import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum ListVideoStatus {initial, loading, success, failure }

class ListVideoState extends Equatable{
  final ListVideoStatus status;
  final VideoList videoList;

  ListVideoState({required this.status, required this.videoList});
  ListVideoState.initial(): status = ListVideoStatus.initial, videoList = VideoList.initial();

  ListVideoState copyWith({
    ListVideoStatus? status,
    VideoList? videoList
  }) {
    return ListVideoState(
      status: status ?? this.status,
      videoList: videoList ?? this.videoList
    );
  }
  @override
  List<Object?> get props => [status, videoList];

  @override
  String toString() {
    return 'ListVideoState{status: $status, videoList: $videoList}';
  }
}