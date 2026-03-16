import '../../model/give_service_review_model.dart';

abstract class GiveServiceReviewEvent {}

class GiveSubmitServiceReviewEvent extends GiveServiceReviewEvent {
  final GiveServiceReviewModel reviewModel;

  GiveSubmitServiceReviewEvent({required this.reviewModel});
}
