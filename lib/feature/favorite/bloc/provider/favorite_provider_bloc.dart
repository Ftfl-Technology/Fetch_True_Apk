import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/favorite_provider_repository.dart';
import '../../repository/favorite_service_repository.dart';
import 'favorite_provider_event.dart';
import 'favorite_provider_state.dart';


class FavoriteProviderBloc extends Bloc<FavoriteProviderEvent, FavoriteProviderState> {
  final FavoriteProviderRepository repository;

  FavoriteProviderBloc(this.repository) : super(FavoriteProviderInitial()) {
    // Add to favorite
    on<AddFavoriteProviderEvent>((event, emit) async {
      emit(FavoriteProviderLoading(event.providerId));
      try {
        final response = await repository.addToFavorite(event.userId, event.providerId);
        emit(FavoriteProviderSuccess(event.providerId, response.message));
      } catch (e) {
        emit(FavoriteProviderFailure(event.providerId, e.toString()));
      }
    });

    // Remove from favorite
    on<RemoveFavoriteProviderEvent>((event, emit) async {
      emit(FavoriteProviderLoading(event.providerId));
      try {
        final response = await repository.removeFromFavorite(event.userId, event.providerId);
        emit(FavoriteProviderSuccess(event.providerId, response.message));
      } catch (e) {
        emit(FavoriteProviderFailure(event.providerId, e.toString()));
      }
    });
  }
}
