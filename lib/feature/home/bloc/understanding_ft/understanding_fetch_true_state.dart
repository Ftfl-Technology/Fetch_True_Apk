import 'package:equatable/equatable.dart';
import '../../model/understanding_fetch_true_model.dart';

abstract class UnderstandingFetchTrueState extends Equatable {
  const UnderstandingFetchTrueState();

  @override
  List<Object?> get props => [];
}

class UnderstandingFetchTrueInitial extends UnderstandingFetchTrueState {}

class UnderstandingFetchTrueLoading extends UnderstandingFetchTrueState {}

class UnderstandingFetchTrueLoaded extends UnderstandingFetchTrueState {
  final List<UnderstandingFetchTrueModel> data;
  const UnderstandingFetchTrueLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class UnderstandingFetchTrueError extends UnderstandingFetchTrueState {
  final String message;
  const UnderstandingFetchTrueError(this.message);

  @override
  List<Object?> get props => [message];
}
