import 'package:equatable/equatable.dart';
import '../../model/finance_recommended_service_model.dart';

abstract class FinanceRecommendedServiceState extends Equatable {
  const FinanceRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class FinanceRecommendedServiceInitial
    extends FinanceRecommendedServiceState {}

class FinanceRecommendedServiceLoading
    extends FinanceRecommendedServiceState {}

class FinanceRecommendedServiceLoaded
    extends FinanceRecommendedServiceState {
  final FinanceRecommendedServiceModel data;

  const FinanceRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FinanceRecommendedServiceError
    extends FinanceRecommendedServiceState {
  final String message;

  const FinanceRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
