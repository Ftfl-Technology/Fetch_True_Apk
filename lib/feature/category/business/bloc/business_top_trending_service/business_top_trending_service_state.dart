import 'package:equatable/equatable.dart';
import '../../model/business_top_trending_service_model.dart';


abstract class BusinessTopTrendingServiceState extends Equatable {
  const BusinessTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class BusinessTopTrendingServiceInitial
    extends BusinessTopTrendingServiceState {}

class BusinessTopTrendingServiceLoading
    extends BusinessTopTrendingServiceState {}

class BusinessTopTrendingServiceLoaded
    extends BusinessTopTrendingServiceState {
  final BusinessTopTrendingServiceModel data;

  const BusinessTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BusinessTopTrendingServiceError
    extends BusinessTopTrendingServiceState {
  final String message;

  const BusinessTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
