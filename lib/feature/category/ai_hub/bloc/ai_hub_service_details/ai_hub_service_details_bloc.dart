import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/ai_hub_service_details_repository.dart';
import 'ai_hub_service_details_event.dart';
import 'ai_hub_service_details_state.dart';


class AiHubServiceDetailsBloc extends Bloc<AiHubServiceDetailsEvent, AiHubServiceDetailsState> {
  final AiHubServiceDetailsRepository repository;

  AiHubServiceDetailsBloc({required this.repository}) : super(AiHubServiceDetailsInitial()) {
    on<FetchAiHubServiceDetails>((event, emit) async {
      emit(AiHubServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(AiHubServiceDetailsLoaded(service));
      } catch (e) {
        emit(AiHubServiceDetailsError(e.toString()));
      }
    });
  }
}
