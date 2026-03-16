import 'package:equatable/equatable.dart';

import '../../model/franchise_popular_service_model.dart';

abstract class FranchisePopularServiceState extends Equatable {
  const FranchisePopularServiceState();

  @override
  List<Object> get props => [];
}

class FranchisePopularServiceInitial
    extends FranchisePopularServiceState {}

class FranchisePopularServiceLoading
    extends FranchisePopularServiceState {}

class FranchisePopularServiceLoaded
    extends FranchisePopularServiceState {
  final FranchisePopularServiceModel data;

  const FranchisePopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FranchisePopularServiceError
    extends FranchisePopularServiceState {
  final String message;

  const FranchisePopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
