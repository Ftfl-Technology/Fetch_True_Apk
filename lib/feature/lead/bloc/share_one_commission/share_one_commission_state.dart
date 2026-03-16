import 'package:equatable/equatable.dart';
import '../../model/share_one_commission_model.dart';

abstract class ShareOneCommissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShareOneCommissionInitial extends ShareOneCommissionState {}

class ShareOneCommissionLoading extends ShareOneCommissionState {}

class ShareOneCommissionLoaded extends ShareOneCommissionState {
  final ShareOneCommissionModel commission;

  ShareOneCommissionLoaded(this.commission);

  @override
  List<Object?> get props => [commission];
}

class ShareOneCommissionError extends ShareOneCommissionState {
  final String message;

  ShareOneCommissionError(this.message);

  @override
  List<Object?> get props => [message];
}
