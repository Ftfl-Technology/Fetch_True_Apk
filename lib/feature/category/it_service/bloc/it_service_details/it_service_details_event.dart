import 'package:equatable/equatable.dart';

abstract class ItServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchItServiceDetails extends ItServiceDetailsEvent {
  final String serviceId;

  FetchItServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
