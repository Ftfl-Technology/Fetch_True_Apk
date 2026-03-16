import 'package:equatable/equatable.dart';
import '../../model/finance_service_details_model.dart';


abstract class FinanceServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FinanceServiceDetailsInitial extends FinanceServiceDetailsState {}

class FinanceServiceDetailsLoading extends FinanceServiceDetailsState {}

class FinanceServiceDetailsLoaded extends FinanceServiceDetailsState {
  final FinanceServiceDetailsModel service;

  FinanceServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class FinanceServiceDetailsError extends FinanceServiceDetailsState {
  final String message;

  FinanceServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
