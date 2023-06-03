import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final String phone;
  final String password;

  Login({required this.phone, required this.password});

  @override
  List<Object> get props => [phone, password];
}

class Logout extends AuthEvent {}

class KeepSession extends AuthEvent {}

class BackFromOnboard extends AuthEvent {}

class NextFromOnboard extends AuthEvent {}