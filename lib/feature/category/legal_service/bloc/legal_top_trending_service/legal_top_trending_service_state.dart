import 'package:equatable/equatable.dart';

import '../../model/legal_top_trending_service_model.dart';

abstract class LegalTopTrendingServiceState extends Equatable {
  const LegalTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class LegalTopTrendingServiceInitial
    extends LegalTopTrendingServiceState {}

class LegalTopTrendingServiceLoading
    extends LegalTopTrendingServiceState {}

class LegalTopTrendingServiceLoaded
    extends LegalTopTrendingServiceState {
  final LegalTopTrendingServiceModel data;

  const LegalTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class LegalTopTrendingServiceError
    extends LegalTopTrendingServiceState {
  final String message;

  const LegalTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
