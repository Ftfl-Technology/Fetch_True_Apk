import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/provider_subscribe_service_repo.dart';
import 'provider_subscribe_event.dart';
import 'provider_subscribe_state.dart';

class ProviderSubscribeBloc
    extends Bloc<ProviderSubscribeEvent, ProviderSubscribeState> {

  final ProviderSubscribeServiceRepo repo;

  ProviderSubscribeBloc(this.repo)
      : super(ProviderSubscribeInitial()) {

    on<FetchSubscribedServices>((event, emit) async {
      emit(ProviderSubscribeLoading());

      try {
        final data = await repo.getSubscribedServices(event.providerId);
        emit(ProviderSubscribeLoaded(data));
      } catch (e) {
        emit(ProviderSubscribeError(e.toString()));
      }
    });
  }
}
