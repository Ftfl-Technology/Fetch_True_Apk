import 'package:equatable/equatable.dart';

abstract class LegalServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLegalServiceDetails extends LegalServiceDetailsEvent {
  final String serviceId;

  FetchLegalServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
