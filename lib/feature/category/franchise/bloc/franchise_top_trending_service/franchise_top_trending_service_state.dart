import 'package:equatable/equatable.dart';

import '../../model/franchise_popular_service_model.dart';
import '../../model/franchise_top_trending_service_model.dart';

abstract class FranchiseTopTrendingServiceState extends Equatable {
  const FranchiseTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class FranchiseTopTrendingServiceInitial
    extends FranchiseTopTrendingServiceState {}

class FranchiseTopTrendingServiceLoading
    extends FranchiseTopTrendingServiceState {}

class FranchiseTopTrendingServiceLoaded
    extends FranchiseTopTrendingServiceState {
  final FranchiseTopTrendingServiceModel data;

  const FranchiseTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FranchiseTopTrendingServiceError
    extends FranchiseTopTrendingServiceState {
  final String message;

  const FranchiseTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
