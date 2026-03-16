import 'package:equatable/equatable.dart';

abstract class FranchiseServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFranchiseServiceDetails extends FranchiseServiceDetailsEvent {
  final String serviceId;

  FetchFranchiseServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
