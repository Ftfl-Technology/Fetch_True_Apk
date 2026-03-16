import 'package:equatable/equatable.dart';

abstract class OnDemandRecommendedProviderEvent extends Equatable {
  const OnDemandRecommendedProviderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnDemandRecommendedProviders extends OnDemandRecommendedProviderEvent {
  final String moduleId;
  final double lat;
  final double lng;

  const FetchOnDemandRecommendedProviders({
    required this.moduleId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [moduleId, lat, lng];
}
