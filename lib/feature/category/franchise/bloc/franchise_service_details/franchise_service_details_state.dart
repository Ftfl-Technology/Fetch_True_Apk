import 'package:equatable/equatable.dart';
import '../../model/franchise_service_details_model.dart';


abstract class FranchiseServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FranchiseServiceDetailsInitial extends FranchiseServiceDetailsState {}

class FranchiseServiceDetailsLoading extends FranchiseServiceDetailsState {}

class FranchiseServiceDetailsLoaded extends FranchiseServiceDetailsState {
  final FranchiseServiceDetailsModel service;

  FranchiseServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class FranchiseServiceDetailsError extends FranchiseServiceDetailsState {
  final String message;

  FranchiseServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
