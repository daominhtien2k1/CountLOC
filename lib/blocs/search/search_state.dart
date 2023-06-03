import '../../models/models.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState {
  SearchStatus searchStatus;
  List<SaveSearch>? saveSearches;
  List<Post>? postList;

  SearchState({required this.searchStatus, this.saveSearches, this.postList});

  SearchState.initial()
      : searchStatus = SearchStatus.initial,
        saveSearches = List<SaveSearch>.empty(growable: true),
        postList = List<Post>.empty(growable: true);

  SearchState copyWith(
      {SearchStatus? searchStatus, List<SaveSearch>? saveSearches, List<Post>? postList}) {
    return SearchState(
        searchStatus: searchStatus ?? this.searchStatus,
        saveSearches: saveSearches ?? this.saveSearches,
        postList: postList ?? this.postList);
  }
}
