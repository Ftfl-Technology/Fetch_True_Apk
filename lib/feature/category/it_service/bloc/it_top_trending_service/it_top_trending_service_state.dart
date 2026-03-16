import 'package:equatable/equatable.dart';

import '../../model/it_top_trending_service_model.dart';

abstract class ItTopTrendingServiceState extends Equatable {
  const ItTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class ItTopTrendingServiceInitial
    extends ItTopTrendingServiceState {}

class ItTopTrendingServiceLoading
    extends ItTopTrendingServiceState {}

class ItTopTrendingServiceLoaded
    extends ItTopTrendingServiceState {
  final ItTopTrendingServiceModel data;

  const ItTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ItTopTrendingServiceError
    extends ItTopTrendingServiceState {
  final String message;

  const ItTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
