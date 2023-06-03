import 'package:bloc/bloc.dart';

import '../../repositories/repositories.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  late final SignupRepository signupRepository;

  SignupBloc({required this.signupRepository}) : super(SignupState.initial()) {
    on<Signup>(
      _onSignup
    );
    on<afterSignUp>(
        _onAfterSignup
    );
  }

  Future<void> _onAfterSignup(afterSignUp event, Emitter<SignupState> emit) async {
    emit (state.copyWith(status: SignupStatus.initial));
  }
  Future<void> _onSignup(
      Signup event,
      Emitter<SignupState> emit) async {

    final phone = event.phone;
    final password = event.password;
    try {
      final signUpRes = await signupRepository.signup(phoneNumber: phone, password: password);
      if( signUpRes.code == "1000")
        emit(state.copyWith(
          status: SignupStatus.success));
      else if( signUpRes.code == "9996")
        emit(state.copyWith(
            status: SignupStatus.userExist));
      else
        emit(state.copyWith(
            status: SignupStatus.failure));
    } catch (error) {
      print('#SIGN UP catch: $error');
      emit(state.copyWith(status: SignupStatus.failure));
    }
  }
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('#SIGN UP OBSERVER: $error');
  }

  @override
  void onTransition(Transition<SignupEvent, SignupState> transition) {
    super.onTransition(transition);
    // print('#POST OBSERVER: $transition');
  }

  @override
  void onEvent(SignupEvent event) {
    super.onEvent(event);
    print('#SIGN UP OBSERVER: $event');
  }

  @override
  void onChange(Change<SignupState> change) {
    super.onChange(change);
    print('#SIGN UP OBSERVER: { stateCurrent: ${change.currentState.status} }');
  }
}