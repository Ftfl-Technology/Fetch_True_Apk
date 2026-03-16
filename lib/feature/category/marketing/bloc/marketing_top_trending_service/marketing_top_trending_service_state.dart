import 'package:equatable/equatable.dart';

import '../../model/marketing_top_trending_service_model.dart';

abstract class MarketingTopTrendingServiceState extends Equatable {
  const MarketingTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class MarketingTopTrendingServiceInitial
    extends MarketingTopTrendingServiceState {}

class MarketingTopTrendingServiceLoading
    extends MarketingTopTrendingServiceState {}

class MarketingTopTrendingServiceLoaded
    extends MarketingTopTrendingServiceState {
  final MarketingTopTrendingServiceModel data;

  const MarketingTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MarketingTopTrendingServiceError
    extends MarketingTopTrendingServiceState {
  final String message;

  const MarketingTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
