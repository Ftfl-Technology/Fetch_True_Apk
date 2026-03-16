import 'package:equatable/equatable.dart';
import '../../model/add_customer_model.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class CreateCustomer extends CustomerEvent {
  final AddCustomerModel customer;

  const CreateCustomer(this.customer);

  @override
  List<Object?> get props => [customer];
}

class GetCustomers extends CustomerEvent {
  const GetCustomers();
}
