// provider_review_state.dart
import 'package:equatable/equatable.dart';

import '../../model/provider_review_model.dart';

abstract class ProviderReviewState extends Equatable {
  const ProviderReviewState();

  @override
  List<Object?> get props => [];
}

class ProviderReviewInitial extends ProviderReviewState {}

class ProviderReviewLoading extends ProviderReviewState {}

class ProviderReviewLoaded extends ProviderReviewState {
  final ProviderReviewModel reviews;

  const ProviderReviewLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ProviderReviewError extends ProviderReviewState {
  final String message;

  const ProviderReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
