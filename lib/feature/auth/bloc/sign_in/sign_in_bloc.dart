import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';
import '../../repository/sign_in_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository repository;

  SignInBloc(this.repository) : super(SignInInitial()) {
    on<SignInButtonPressed>((event, emit) async {
      emit(SignInLoading());
      try {
        final response = await repository.signIn(event.signInData);
        emit(SignInSuccess(response));
      } catch (e) {
        emit(SignInFailure(e.toString()));
      }
    });
  }
}
