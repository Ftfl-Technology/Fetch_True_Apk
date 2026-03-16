// provider_review_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/provider_review_repository.dart';
import 'provider_review_event.dart';
import 'provider_review_state.dart';

class ProviderReviewBloc extends Bloc<ProviderReviewEvent, ProviderReviewState> {
  final ProviderReviewRepository repository;

  ProviderReviewBloc(this.repository) : super(ProviderReviewInitial()) {
    on<FetchProviderReviews>((event, emit) async {
      emit(ProviderReviewLoading());
      try {
        final data = await repository.getProviderReviews(event.providerId);
        if (data != null) {
          emit(ProviderReviewLoaded(data));
        } else {
          emit(const ProviderReviewError("Failed to load reviews"));
        }
      } catch (e) {
        emit(ProviderReviewError(e.toString()));
      }
    });
  }
}
