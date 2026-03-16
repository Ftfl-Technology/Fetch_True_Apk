import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../../repository/customer_repository.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;

  CustomerBloc(this.repository) : super(CustomerInitial()) {
    on<CreateCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        final result = await repository.createCustomer(event.customer);
        if (result != null) {
          emit(CustomerSuccess(result));
        } else {
          emit(const CustomerFailure("Failed to create customer"));
        }
      } catch (e) {
        emit(CustomerFailure(e.toString()));
      }
    });

    on<GetCustomers>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customers = await repository.getCustomers();
        emit(CustomersLoaded(customers));
      } catch (e) {
        emit(CustomerFailure(e.toString()));
      }
    });
  }
}
