import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class PersonalPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonalPostFetched extends PersonalPostEvent {
  final String accountId;
  PersonalPostFetched({required this.accountId});
}

class PersonalPostReload extends PersonalPostEvent {
  final String accountId;
  PersonalPostReload({required this.accountId});
}

class PersonalPostLike extends PersonalPostEvent {
  final Post post;
  PersonalPostLike({required this.post});
}