import 'package:equatable/equatable.dart';

import '../../models/auth_user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loginFail, firstTimeUseApp }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser authUser;

  AuthState.initial(): status = AuthStatus.unauthenticated, authUser = AuthUser.initial();
  AuthState({required this.status, required this.authUser});

  AuthState copyWith({AuthStatus? status, AuthUser? authUser}) {
    return AuthState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser
    );
  }
  @override
  List<Object> get props => [status, authUser];
}