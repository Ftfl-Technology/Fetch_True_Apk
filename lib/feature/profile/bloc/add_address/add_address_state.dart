import 'package:equatable/equatable.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}
class AddressLoading extends AddressState {}
class AddressSuccess extends AddressState {
  final String message;
  AddressSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class AddressFailure extends AddressState {
  final String error;
  AddressFailure(this.error);
  @override
  List<Object?> get props => [error];
}
