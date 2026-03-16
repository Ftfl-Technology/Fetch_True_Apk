import 'package:equatable/equatable.dart';

abstract class ProviderReviewEvent extends Equatable {
  const ProviderReviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchProviderReviews extends ProviderReviewEvent {
  final String providerId;

  const FetchProviderReviews(this.providerId);

  @override
  List<Object?> get props => [providerId];
}
