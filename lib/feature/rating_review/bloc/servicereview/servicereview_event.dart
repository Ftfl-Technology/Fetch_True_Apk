import 'package:equatable/equatable.dart';

abstract class ServiceReviewEvent extends Equatable {
  const ServiceReviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceReviews extends ServiceReviewEvent {
  final String serviceId;
  const FetchServiceReviews(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
