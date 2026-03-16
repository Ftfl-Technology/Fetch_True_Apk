import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/sign_up_repository.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository repository;

  SignUpBloc(this.repository) : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpLoading());
      try {
        final response = await repository.registerUser(event.signUpData);
        emit(SignUpSuccess(response));
      } catch (e) {
        emit(SignUpFailure(e.toString()));
      }
    });
  }
}
