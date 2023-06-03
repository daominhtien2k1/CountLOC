import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String keyword;

  Search({required this.keyword});
}

class GetSavedSearch extends SearchEvent{
  GetSavedSearch();
}