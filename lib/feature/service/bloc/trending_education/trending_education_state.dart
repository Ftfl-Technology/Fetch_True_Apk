import 'package:equatable/equatable.dart';
import '../../model/trending_education_model.dart';

abstract class TrendingEducationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrendingEducationInitial extends TrendingEducationState {}

class TrendingEducationLoading extends TrendingEducationState {}

class TrendingEducationLoaded extends TrendingEducationState {
  final List<TrendingEducationModel> educations;
  TrendingEducationLoaded(this.educations);

  @override
  List<Object?> get props => [educations];
}

class TrendingEducationError extends TrendingEducationState {
  final String message;
  TrendingEducationError(this.message);

  @override
  List<Object?> get props => [message];
}
