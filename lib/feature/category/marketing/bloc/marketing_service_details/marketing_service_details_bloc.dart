import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/marketing_service_details_repository.dart';
import 'marketing_service_details_event.dart';
import 'marketing_service_details_state.dart';


class MarketingServiceDetailsBloc extends Bloc<MarketingServiceDetailsEvent, MarketingServiceDetailsState> {
  final MarketingServiceRepository repository;

  MarketingServiceDetailsBloc({required this.repository}) : super(MarketingServiceDetailsInitial()) {
    on<FetchMarketingServiceDetails>((event, emit) async {
      emit(MarketingServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(MarketingServiceDetailsLoaded(service));
      } catch (e) {
        emit(MarketingServiceDetailsError(e.toString()));
      }
    });
  }
}
