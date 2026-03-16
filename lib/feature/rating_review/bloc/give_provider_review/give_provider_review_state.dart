abstract class GiveProviderReviewState {}

class GiveProviderReviewInitial extends GiveProviderReviewState {}

class GiveProviderReviewLoading extends GiveProviderReviewState {}

class GiveProviderReviewSuccess extends GiveProviderReviewState {
  final String message;

  GiveProviderReviewSuccess({required this.message});
}

class GiveProviderReviewFailure extends GiveProviderReviewState {
  final String error;

  GiveProviderReviewFailure({required this.error});
}
