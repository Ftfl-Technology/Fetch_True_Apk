import 'package:equatable/equatable.dart';

abstract class OnDemandPopularProviderEvent extends Equatable {
  const OnDemandPopularProviderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnDemandPopularProviders extends OnDemandPopularProviderEvent {
  final String moduleId;
  final double lat;
  final double lng;

  const FetchOnDemandPopularProviders({
    required this.moduleId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [moduleId, lat, lng];
}
