import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/payu_gateway_model.dart';
import '../../model/payu_gateway_response_model.dart';
import '../../repository/payu_gateway_repository.dart';
part 'payu_gateway_event.dart';
part 'payu_gateway_state.dart';

class PayUGatewayBloc extends Bloc<PayUGatewayEvent, PayUGatewayState> {
  final PayUGatewayRepository repository;

  PayUGatewayBloc(this.repository) : super(PayUGatewayInitial()) {
    on<CreatePayULinkEvent>((event, emit) async {
      emit(PayUGatewayLoading());
      try {
        final response = await repository.initiatePayment(event.model);
        if (response != null && response.status == 0) {
          emit(PayUGatewaySuccess(response));
        } else {
          emit(const PayUGatewayFailure("Failed to generate payment link"));
        }
      } catch (e) {
        emit(PayUGatewayFailure(e.toString()));
      }
    });
  }
}
