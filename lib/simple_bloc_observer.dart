import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   print('#GLOBAL OBSERVER: ${bloc.runtimeType} $event');
  // }
  //
  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   super.onChange(bloc, change);
  //   print('#GLOBAL OBSERVER: ${bloc.runtimeType} $change');
  // }
  //
  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   print(transition);
  // }
  //
  // @override
  // void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
  //   print('${bloc.runtimeType} $error');
  //   super.onError(bloc, error, stackTrace);
  // }
}