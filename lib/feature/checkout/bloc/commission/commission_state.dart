// commission_state.dart
import 'package:equatable/equatable.dart';

import '../../model/commission_model.dart';

abstract class CommissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommissionInitial extends CommissionState {}

class CommissionLoading extends CommissionState {}

class CommissionLoaded extends CommissionState {
  final CommissionModel commission;
  CommissionLoaded(this.commission);

  @override
  List<Object?> get props => [commission];
}

class CommissionError extends CommissionState {
  final String message;
  CommissionError(this.message);

  @override
  List<Object?> get props => [message];
}
