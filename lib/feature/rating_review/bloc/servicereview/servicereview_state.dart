import 'package:equatable/equatable.dart';
import '../../model/service_review_model.dart';

abstract class ServiceReviewState extends Equatable {
  const ServiceReviewState();

  @override
  List<Object?> get props => [];
}

class ServiceReviewInitial extends ServiceReviewState {}

class ServiceReviewLoading extends ServiceReviewState {}

class ServiceReviewLoaded extends ServiceReviewState {
  final ServiceReviewResponse data;
  const ServiceReviewLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceReviewError extends ServiceReviewState {
  final String message;
  const ServiceReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
