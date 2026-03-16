import 'package:equatable/equatable.dart';

abstract class FinanceServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFinanceServiceDetails extends FinanceServiceDetailsEvent {
  final String serviceId;

  FetchFinanceServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
