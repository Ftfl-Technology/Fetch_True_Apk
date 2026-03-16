import 'package:equatable/equatable.dart';
import '../../model/sign_up_response_model.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignUpResponseModel response;
  SignUpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);

  @override
  List<Object?> get props => [error];
}
