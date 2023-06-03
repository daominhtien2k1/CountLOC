import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Signup extends SignupEvent {
  final String phone;
  final String password;
  Signup({required this.phone, required this.password});

  @override
  List<Object> get props => [phone, password];
}

class afterSignUp extends SignupEvent {
  @override
  List<Object> get props => [];
}