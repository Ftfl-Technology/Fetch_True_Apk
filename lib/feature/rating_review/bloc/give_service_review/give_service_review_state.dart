abstract class GiveServiceReviewState {}

class GiveServiceReviewInitial extends GiveServiceReviewState {}

class GiveServiceReviewLoading extends GiveServiceReviewState {}

class GiveServiceReviewSuccess extends GiveServiceReviewState {
  final String message;

  GiveServiceReviewSuccess({required this.message});
}

class GiveServiceReviewFailure extends GiveServiceReviewState {
  final String error;

  GiveServiceReviewFailure({required this.error});
}
