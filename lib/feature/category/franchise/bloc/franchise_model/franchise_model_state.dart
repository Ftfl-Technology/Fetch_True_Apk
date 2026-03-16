import '../../model/franchise_model.dart';

abstract class FranchiseModelState {}

class FranchiseModelInitial extends FranchiseModelState {}

class FranchiseModelLoading extends FranchiseModelState {}

class FranchiseModelLoaded extends FranchiseModelState {
  final FranchiseModelResponse data;

  FranchiseModelLoaded(this.data);
}

class FranchiseModelError extends FranchiseModelState {
  final String message;

  FranchiseModelError(this.message);
}
