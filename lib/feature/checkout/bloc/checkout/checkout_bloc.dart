import 'package:fetchtrue/feature/checkout/bloc/checkout/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/checkout_repository.dart';
import 'checkout_event.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckOutRepository repository;

  CheckoutBloc({required this.repository}) : super(CheckoutInitial()) {
    on<CheckoutRequestEvent>((event, emit) async {
      emit(CheckoutLoading());

      try {
        final result = await repository.checkout(event.model);
        if (result != null) {
          emit(CheckoutSuccess(result));
        } else {
          emit(CheckoutFailure("Checkout failed: No data returned"));
        }
      } catch (e) {
        emit(CheckoutFailure(e.toString()));
      }
    });
  }
}
