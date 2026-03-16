import 'package:equatable/equatable.dart';

import '../../model/FiveXModel.dart';

abstract class FiveXState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FiveXInitial extends FiveXState {}

class FiveXLoading extends FiveXState {}

class FiveXLoaded extends FiveXState {
  final List<FiveXModel> data;

  FiveXLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class FiveXError extends FiveXState {
  final String message;

  FiveXError(this.message);

  @override
  List<Object?> get props => [message];
}
