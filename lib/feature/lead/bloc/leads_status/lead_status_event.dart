// lead_status_event.dart
import 'package:equatable/equatable.dart';

abstract class LeadStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLeadStatusEvent extends LeadStatusEvent {
  final String checkoutId;

  FetchLeadStatusEvent(this.checkoutId);

  @override
  List<Object?> get props => [checkoutId];
}
