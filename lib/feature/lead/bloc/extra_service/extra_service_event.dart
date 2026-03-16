import 'package:equatable/equatable.dart';

abstract class ExtraServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchExtraServiceEvent extends ExtraServiceEvent {
  final String checkoutId;

  FetchExtraServiceEvent(this.checkoutId);

  @override
  List<Object?> get props => [checkoutId];
}
