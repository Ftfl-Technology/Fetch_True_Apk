import 'package:equatable/equatable.dart';
import '../../model/add_customer_model.dart';
import '../../model/customer_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final AddCustomerModel customer;

  const CustomerSuccess(this.customer);

  @override
  List<Object?> get props => [customer];
}

class CustomersLoaded extends CustomerState {
  final List<CustomerModel> customers;

  const CustomersLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerFailure extends CustomerState {
  final String error;

  const CustomerFailure(this.error);

  @override
  List<Object?> get props => [error];
}
