import 'local_models.dart';

class Search{
  final User user;
  final String keyword;
  final DateTime createdTime;

  const Search({
    required this.user,
    required this.keyword,
    required this.createdTime
  });
}