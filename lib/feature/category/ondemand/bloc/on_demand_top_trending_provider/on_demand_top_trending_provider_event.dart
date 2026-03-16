import 'package:equatable/equatable.dart';

abstract class OnDemandTopTrendingProviderEvent extends Equatable {
  const OnDemandTopTrendingProviderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnDemandTopTrendingProviders extends OnDemandTopTrendingProviderEvent {
  final String moduleId;
  final double lat;
  final double lng;

  const FetchOnDemandTopTrendingProviders({
    required this.moduleId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [moduleId, lat, lng];
}
