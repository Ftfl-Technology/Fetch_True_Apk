import 'package:equatable/equatable.dart';

abstract class BankKycState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankKycInitial extends BankKycState {}

class BankKycLoading extends BankKycState {}

class BankKycSuccess extends BankKycState {
  final dynamic data;
  BankKycSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class BankKycError extends BankKycState {
  final String message;
  BankKycError(this.message);

  @override
  List<Object?> get props => [message];
}
