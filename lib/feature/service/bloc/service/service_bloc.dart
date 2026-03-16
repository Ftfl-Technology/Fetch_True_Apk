// bloc/service_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/service_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc(this.repository) : super(ServiceInitial()) {
    on<GetServices>((event, emit) async {
      emit(ServiceLoading());
      try {
        final services = await repository.getServices();
        emit(ServiceLoaded(services));
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });
  }
}
