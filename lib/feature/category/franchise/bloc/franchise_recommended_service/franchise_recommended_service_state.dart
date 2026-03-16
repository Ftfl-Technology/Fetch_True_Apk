import 'package:equatable/equatable.dart';
import '../../model/franchise_recommended_service_model.dart';

abstract class FranchiseRecommendedServiceState extends Equatable {
  const FranchiseRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class FranchiseRecommendedServiceInitial
    extends FranchiseRecommendedServiceState {}

class FranchiseRecommendedServiceLoading
    extends FranchiseRecommendedServiceState {}

class FranchiseRecommendedServiceLoaded
    extends FranchiseRecommendedServiceState {
  final FranchiseRecommendedServiceModel data;

  const FranchiseRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FranchiseRecommendedServiceError
    extends FranchiseRecommendedServiceState {
  final String message;

  const FranchiseRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
