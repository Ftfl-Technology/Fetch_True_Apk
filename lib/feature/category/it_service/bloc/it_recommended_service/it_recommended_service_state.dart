import 'package:equatable/equatable.dart';

import '../../model/it_recommended_service_model.dart';

abstract class ItRecommendedServiceState extends Equatable {
  const ItRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class ItRecommendedServiceInitial
    extends ItRecommendedServiceState {}

class ItRecommendedServiceLoading
    extends ItRecommendedServiceState {}

class ItRecommendedServiceLoaded
    extends ItRecommendedServiceState {
  final ItRecommendedServiceModel data;

  const ItRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ItRecommendedServiceError
    extends ItRecommendedServiceState {
  final String message;

  const ItRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
