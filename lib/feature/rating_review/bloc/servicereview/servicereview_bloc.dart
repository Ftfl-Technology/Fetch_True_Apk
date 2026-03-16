import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../service/repository/service_review_service.dart';
import 'servicereview_event.dart';
import 'servicereview_state.dart';

class ServiceReviewBloc
    extends Bloc<ServiceReviewEvent, ServiceReviewState> {

  final ReviewService reviewService;

  ServiceReviewBloc(this.reviewService)
      : super(ServiceReviewInitial()) {
    on<FetchServiceReviews>(_onFetchReviews);
  }

  Future<void> _onFetchReviews(
      FetchServiceReviews event,
      Emitter<ServiceReviewState> emit,
      ) async {
    emit(ServiceReviewLoading());

    try {
      final response =
      await reviewService.fetchReviews(event.serviceId);

      if (response != null && response.success) {
        emit(ServiceReviewLoaded(response));
      } else {
        emit(const ServiceReviewError("No reviews found"));
      }
    } catch (e) {
      emit(const ServiceReviewError("Failed to load reviews"));
    }
  }
}
