import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class PersonalInfoState extends Equatable {
  final UserInfo userInfo;

  PersonalInfoState({required this.userInfo});

  PersonalInfoState.initial() : userInfo = UserInfo.initial();

  PersonalInfoState copyWith({UserInfo? userInfo}) {
    return PersonalInfoState(
      userInfo: userInfo ?? this.userInfo,
    );
  }

  @override
  List<Object?> get props => [userInfo];

}
