import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/service_wise_provider_subscriber_repository.dart';
import 'service_wise_provider_subscriber_event.dart';
import 'service_wise_provider_subscriber_state.dart';

class ServiceWiseProviderSubscriberBloc extends Bloc<
    ServiceWiseProviderSubscriberEvent,
    ServiceWiseProviderSubscriberState> {
  final ServiceWiseProviderSubscriberRepository repository;

  ServiceWiseProviderSubscriberBloc(this.repository)
      : super(ServiceWiseProviderSubscriberInitial()) {
    on<FetchServiceWiseProviderSubscriber>(_onFetch);
  }

  Future<void> _onFetch(
      FetchServiceWiseProviderSubscriber event,
      Emitter<ServiceWiseProviderSubscriberState> emit,
      ) async {
    emit(ServiceWiseProviderSubscriberLoading());
    try {
      final providers =
      await repository.getServiceWiseProviderSubscriber(event.serviceId);
      emit(ServiceWiseProviderSubscriberLoaded(providers));
    } catch (e) {
      emit(ServiceWiseProviderSubscriberError(e.toString()));
    }
  }
}
