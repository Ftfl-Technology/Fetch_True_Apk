import 'package:equatable/equatable.dart';


abstract class MarketingTopTrendingServiceEvent extends Equatable {
  const MarketingTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchMarketingTopTrendingServices extends MarketingTopTrendingServiceEvent {
  final String moduleId;

  const FetchMarketingTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
