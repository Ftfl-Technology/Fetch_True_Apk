import 'package:equatable/equatable.dart';

abstract class BusinessServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBusinessServiceDetails extends BusinessServiceDetailsEvent {
  final String serviceId;

  FetchBusinessServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
