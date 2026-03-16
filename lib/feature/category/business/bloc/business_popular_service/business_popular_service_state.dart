import 'package:equatable/equatable.dart';

import '../../model/business_popular_service_model.dart';


abstract class BusinessPopularServiceState extends Equatable {
  const BusinessPopularServiceState();

  @override
  List<Object> get props => [];
}

class BusinessPopularServiceInitial
    extends BusinessPopularServiceState {}

class BusinessPopularServiceLoading
    extends BusinessPopularServiceState {}

class BusinessPopularServiceLoaded
    extends BusinessPopularServiceState {
  final BusinessPopularServiceModel data;

  const BusinessPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BusinessPopularServiceError
    extends BusinessPopularServiceState {
  final String message;

  const BusinessPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
