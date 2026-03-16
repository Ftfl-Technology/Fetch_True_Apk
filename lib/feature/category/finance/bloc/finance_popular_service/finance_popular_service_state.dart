import 'package:equatable/equatable.dart';

import '../../model/finance_popular_service_model.dart';


abstract class FinancePopularServiceState extends Equatable {
  const FinancePopularServiceState();

  @override
  List<Object> get props => [];
}

class FinancePopularServiceInitial
    extends FinancePopularServiceState {}

class FinancePopularServiceLoading
    extends FinancePopularServiceState {}

class FinancePopularServiceLoaded
    extends FinancePopularServiceState {
  final FinancePopularServiceModel data;

  const FinancePopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FinancePopularServiceError
    extends FinancePopularServiceState {
  final String message;

  const FinancePopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
