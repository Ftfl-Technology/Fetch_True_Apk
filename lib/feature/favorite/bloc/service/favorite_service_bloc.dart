import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/favorite_service_repository.dart';
import 'favorite_service_event.dart';
import 'favorite_service_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteServiceRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteInitial()) {
    // Add to favorite
    on<AddFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading(event.serviceId)); // 👈 serviceId pass
      try {
        final response = await repository.addToFavorite(event.userId, event.serviceId);
        emit(FavoriteSuccess(event.serviceId, response.message));
      } catch (e) {
        emit(FavoriteFailure(event.serviceId, e.toString()));
      }
    });

    // Remove from favorite
    on<RemoveFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading(event.serviceId)); // 👈 serviceId pass
      try {
        final response = await repository.removeFromFavorite(event.userId, event.serviceId);
        emit(FavoriteSuccess(event.serviceId, response.message));
      } catch (e) {
        emit(FavoriteFailure(event.serviceId, e.toString()));
      }
    });
  }
}
