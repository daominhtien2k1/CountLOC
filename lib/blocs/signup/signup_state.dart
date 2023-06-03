import 'package:equatable/equatable.dart';

enum SignupStatus {initial, success, failure , userExist }

class SignupState extends Equatable {
  SignupState.initial(): status = SignupStatus.initial;
  SignupState({required this.status});

  final SignupStatus status;

  SignupState copyWith({
    SignupStatus? status,
  }) {
    return SignupState(
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'PostState{status: $status}';
  }

  @override
  List<Object> get props => [status];
}