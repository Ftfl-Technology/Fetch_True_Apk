import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/finance_service_details_repository.dart';
import 'finance_service_details_event.dart';
import 'finance_service_details_state.dart';


class FinanceServiceDetailsBloc extends Bloc<FinanceServiceDetailsEvent, FinanceServiceDetailsState> {
  final FinanceServiceDetailsRepository repository;

  FinanceServiceDetailsBloc({required this.repository}) : super(FinanceServiceDetailsInitial()) {
    on<FetchFinanceServiceDetails>((event, emit) async {
      emit(FinanceServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(FinanceServiceDetailsLoaded(service));
      } catch (e) {
        emit(FinanceServiceDetailsError(e.toString()));
      }
    });
  }
}
