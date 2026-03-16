import 'package:equatable/equatable.dart';
import 'package:fetchtrue/feature/auth/model/sign_in_model.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInButtonPressed extends SignInEvent {
  final SignInModel signInData;

  const SignInButtonPressed(this.signInData);

  @override
  List<Object?> get props => [signInData];
}
