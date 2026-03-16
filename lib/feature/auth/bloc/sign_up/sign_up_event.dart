import 'package:equatable/equatable.dart';
import '../../model/sign_up_model.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  final SignUpModel signUpData;
  SignUpButtonPressed(this.signUpData);

  @override
  List<Object?> get props => [signUpData];
}
