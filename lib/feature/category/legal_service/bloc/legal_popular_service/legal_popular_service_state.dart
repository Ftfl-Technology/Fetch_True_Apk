import 'package:equatable/equatable.dart';

import '../../model/legal_popular_service_model.dart';

abstract class LegalPopularServiceState extends Equatable {
  const LegalPopularServiceState();

  @override
  List<Object> get props => [];
}

class LegalPopularServiceInitial
    extends LegalPopularServiceState {}

class LegalPopularServiceLoading
    extends LegalPopularServiceState {}

class LegalPopularServiceLoaded
    extends LegalPopularServiceState {
  final LegalPopularServiceModel data;

  const LegalPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class LegalPopularServiceError
    extends LegalPopularServiceState {
  final String message;

  const LegalPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
