import 'package:equatable/equatable.dart';


abstract class MarketingPopularServiceEvent extends Equatable {
  const MarketingPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchMarketingPopularServices extends MarketingPopularServiceEvent {
  final String moduleId;

  const FetchMarketingPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
