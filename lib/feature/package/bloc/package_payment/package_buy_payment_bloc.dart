import 'package:fetchtrue/feature/package/bloc/package_payment/package_buy_payment_event.dart';
import 'package:fetchtrue/feature/package/bloc/package_payment/package_buy_payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/package_buy_payment_repository.dart';


class PackagePaymentBloc extends Bloc<PackagePaymentEvent, PackagePaymentState> {
  final PackageBuyPaymentRepository repository;

  PackagePaymentBloc({required this.repository}) : super(PackagePaymentInitial()) {
    on<CreatePaymentLinkEvent>(_onCreatePaymentLink);
  }

  Future<void> _onCreatePaymentLink(
      CreatePaymentLinkEvent event,
      Emitter<PackagePaymentState> emit,
      ) async {
    emit(PackagePaymentLoading());
    try {
      final response = await repository.createPaymentLink(event.paymentModel);
      emit(PackagePaymentSuccess(response));
    } catch (e) {
      emit(PackagePaymentFailure(e.toString()));
    }
  }
}
