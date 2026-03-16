import 'package:equatable/equatable.dart';

abstract class UpcomingCommissionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUpcomingCommission extends UpcomingCommissionEvent {
  final String checkoutId;

  FetchUpcomingCommission(this.checkoutId);

  @override
  List<Object?> get props => [checkoutId];
}
