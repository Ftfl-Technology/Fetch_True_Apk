import 'package:equatable/equatable.dart';

import '../../model/service_model.dart';
import '../../model/trending_franchise_model.dart';

abstract class FranchiseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FranchiseInitial extends FranchiseState {}

class FranchiseLoading extends FranchiseState {}

class FranchiseLoaded extends FranchiseState {
  final List<TrendingFranchiseModel> franchises;
  FranchiseLoaded(this.franchises);

  @override
  List<Object?> get props => [franchises];
}

class FranchiseError extends FranchiseState {
  final String message;
  FranchiseError(this.message);

  @override
  List<Object?> get props => [message];
}
