// commission_event.dart
import 'package:equatable/equatable.dart';

abstract class CommissionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCommission extends CommissionEvent {}
