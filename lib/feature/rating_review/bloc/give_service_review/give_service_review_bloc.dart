import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/give_service_review_repository.dart';
import 'give_service_review_event.dart';
import 'give_service_review_state.dart';

class GiveServiceReviewBloc
    extends Bloc<GiveServiceReviewEvent, GiveServiceReviewState> {
  final GiveServiceReviewRepository repository;

  GiveServiceReviewBloc({required this.repository})
      : super(GiveServiceReviewInitial()) {
    on<GiveSubmitServiceReviewEvent>(_onSubmitServiceReview);
  }

  Future<void> _onSubmitServiceReview(
      GiveSubmitServiceReviewEvent event,
      Emitter<GiveServiceReviewState> emit,
      ) async {
    emit(GiveServiceReviewLoading());

    try {
      final response =
      await repository.giveServiceReview(event.reviewModel);

      if (response.success) {
        emit(GiveServiceReviewSuccess(message: response.message));
      } else {
        emit(GiveServiceReviewFailure(error: response.message));
      }
    } catch (e) {
      emit(GiveServiceReviewFailure(error: e.toString()));
    }
  }
}
