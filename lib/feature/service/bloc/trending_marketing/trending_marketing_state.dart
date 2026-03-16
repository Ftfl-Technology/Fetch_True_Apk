import 'package:equatable/equatable.dart';
import '../../model/trending_marketing_model.dart';

abstract class TrendingMarketingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrendingMarketingInitial extends TrendingMarketingState {}

class TrendingMarketingLoading extends TrendingMarketingState {}

class TrendingMarketingLoaded extends TrendingMarketingState {
  final List<TrendingMarketingModel> marketing;
  TrendingMarketingLoaded(this.marketing);

  @override
  List<Object?> get props => [marketing];
}

class TrendingMarketingError extends TrendingMarketingState {
  final String message;
  TrendingMarketingError(this.message);

  @override
  List<Object?> get props => [message];
}
