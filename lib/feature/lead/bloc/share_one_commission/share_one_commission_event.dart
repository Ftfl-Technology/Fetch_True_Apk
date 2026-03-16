import 'package:equatable/equatable.dart';

abstract class ShareOneCommissionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchShareOneCommission extends ShareOneCommissionEvent {
  final String id;

  FetchShareOneCommission(this.id);

  @override
  List<Object> get props => [id];
}
