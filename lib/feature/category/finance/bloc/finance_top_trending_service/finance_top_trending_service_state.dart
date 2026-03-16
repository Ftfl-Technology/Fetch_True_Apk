import 'package:equatable/equatable.dart';
import '../../model/finance_top_trending_service_model.dart';


abstract class FinanceTopTrendingServiceState extends Equatable {
  const FinanceTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class FinanceTopTrendingServiceInitial
    extends FinanceTopTrendingServiceState {}

class FinanceTopTrendingServiceLoading
    extends FinanceTopTrendingServiceState {}

class FinanceTopTrendingServiceLoaded
    extends FinanceTopTrendingServiceState {
  final FinanceTopTrendingServiceModel data;

  const FinanceTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class FinanceTopTrendingServiceError
    extends FinanceTopTrendingServiceState {
  final String message;

  const FinanceTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
