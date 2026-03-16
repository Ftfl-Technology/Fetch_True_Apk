import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/give_provider_review_repository.dart';
import 'give_provider_review_event.dart';
import 'give_provider_review_state.dart';

class GiveProviderReviewBloc
    extends Bloc<GiveProviderReviewEvent, GiveProviderReviewState> {
  final GiveProviderReviewRepository repository;

  GiveProviderReviewBloc({required this.repository})
      : super(GiveProviderReviewInitial()) {
    on<GiveSubmitProviderReviewEvent>(_onSubmitProviderReview);
  }

  Future<void> _onSubmitProviderReview(
      GiveSubmitProviderReviewEvent event,
      Emitter<GiveProviderReviewState> emit,
      ) async {
    emit(GiveProviderReviewLoading());

    try {
      final response =
      await repository.giveProviderReview(event.reviewModel);

      if (response.success) {
        emit(GiveProviderReviewSuccess(message: response.message));
      } else {
        emit(GiveProviderReviewFailure(error: response.message));
      }
    } catch (e) {
      emit(GiveProviderReviewFailure(error: e.toString()));
    }
  }
}
