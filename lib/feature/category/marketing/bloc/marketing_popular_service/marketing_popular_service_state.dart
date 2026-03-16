import 'package:equatable/equatable.dart';

import '../../model/marketing_popular_service_model.dart';


abstract class MarketingPopularServiceState extends Equatable {
  const MarketingPopularServiceState();

  @override
  List<Object> get props => [];
}

class MarketingPopularServiceInitial extends MarketingPopularServiceState {}

class MarketingPopularServiceLoading extends MarketingPopularServiceState {}

class MarketingPopularServiceLoaded
    extends MarketingPopularServiceState {
  final MarketingPopularServiceModel data;

  const MarketingPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MarketingPopularServiceError
    extends MarketingPopularServiceState {
  final String message;

  const MarketingPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
