import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../blocs/search/search_bloc.dart';
import '../../../blocs/search/search_event.dart';
import '../../../blocs/search/search_state.dart';
import '../../newsfeed/widgets/post_container.dart';

class SearchProfileScreen extends StatefulWidget {
  @override
  State<SearchProfileScreen> createState() => _SearchProfileScreenState();
}

class _SearchProfileScreenState extends State<SearchProfileScreen> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchshia',
    'flutter',
    'nodejs',
    'hello',
    'hmmmmmm'
  ];

  late List<String> filteredSearchHistory;

  String? selectedTerm;

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((element) => element == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  String? filter;

  List<String> filterSearchTerms({
    required filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void getHistory(BuildContext context) async {
    // List<SaveSearch> tempHistory = BlocProvider.of<SearchBloc>(context).add(GetSavedSearch());
    // _searchHistory = BlocProvider.of<SearchBloc>(context).add(GetSavedSearch());
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.black,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   backgroundColor: Colors.white,
      //   // title:
      //   // titleSpacing: 0.0,
      // ),
      body: FloatingSearchBar(
        height: 57,
        controller: controller,
        body: SearchResultListView(searchTerm: null),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search.....',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search.....',
        actions: [FloatingSearchBarAction.searchToClear()],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          context.read<SearchBloc>().add(Search(keyword: query));

        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
                color: Colors.white,
                elevation: 4,
                child: Builder(
                  builder: (context) {
                    // _searchHistory = context.read<SearchBloc>().add(GetSavedSearch());
                    if (filteredSearchHistory.isEmpty &&
                        controller.query.isEmpty) {
                      return Container(
                        height: 56,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Start Searching',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    } else if (filteredSearchHistory.isEmpty) {
                      return ListTile(
                        title: Text(controller.query),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          setState(() {
                            addSearchTerm(controller.query);
                            selectedTerm = controller.query;
                          });
                          controller.close();
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredSearchHistory
                            .map((term) => ListTile(
                                  title: Text(
                                    term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: const Icon(Icons.history),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        deleteSearchTerm(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      putSearchTermFirst(term);
                                      selectedTerm = term;
                                    });
                                    controller.close();
                                  },
                                ))
                            .toList(),
                      );
                    }
                  },
                )),
          );
        },
      ),
    );
  }
}

class SearchResultListView extends StatelessWidget {
  final String? searchTerm;

  const SearchResultListView({Key? key, required this.searchTerm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
      child: CustomScrollView(slivers: [PostSearchList()]),
    );
  }
}

class PostSearchList extends StatefulWidget {
  const PostSearchList({
    Key? key,
  }) : super(key: key);

  @override
  State<PostSearchList> createState() => _PostSearchListState();
}

class _PostSearchListState extends State<PostSearchList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state.postList?.length != null) {
        final size = state.postList?.length;
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return index >= size!
              ? const CircularProgressIndicator()
              : PostContainer(post: state.postList![index]);
        }, childCount: size));
      } else {
        return Text("Không có gì cả");
      }
    });
  }
}
