import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchRepository searchRepository;

  SearchBloc() : super(SearchState.initial()) {
    searchRepository = SearchRepository();

    on<Search>(_onSearch);
    on<GetSavedSearch>(_onGetSavedSearch);
  }

  Future<void> _onGetSavedSearch(
      GetSavedSearch event, Emitter<SearchState> emit) async {
    try {
      final searchListData = await searchRepository.fetchSaveSearchList();
      emit(state.copyWith(searchStatus: SearchStatus.loading));
      return emit(SearchState(
          searchStatus: SearchStatus.success, saveSearches: searchListData));
    } catch (_) {
      emit(SearchState(searchStatus: SearchStatus.failure));
    }
  }

  Future<void> _onSearch(Search event, Emitter<SearchState> emit) async {
    String keyword = event.keyword;
    try {
      print("postListData?.posts.length");
      final postListData = await searchRepository.searchSth(keyword: keyword);
      print(postListData?.posts.length);

      state.postList = postListData?.posts;
      emit(
        SearchState(
          searchStatus: SearchStatus.success,
          postList: state.postList,
        ),
      );
    } catch (_) {
      emit(SearchState(searchStatus: SearchStatus.failure));
    }
  }
}
