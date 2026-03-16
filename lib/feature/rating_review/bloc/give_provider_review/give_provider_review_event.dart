import '../../model/give_provider_review_model.dart';

abstract class GiveProviderReviewEvent {}

class GiveSubmitProviderReviewEvent extends GiveProviderReviewEvent {
  final GiveProviderReviewModel reviewModel;

  GiveSubmitProviderReviewEvent({required this.reviewModel});
}
