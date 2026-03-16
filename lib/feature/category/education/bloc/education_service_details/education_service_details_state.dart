import 'package:equatable/equatable.dart';
import '../../model/education_service_details_model.dart';

abstract class EducationServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationServiceDetailsInitial extends EducationServiceDetailsState {}

class EducationServiceDetailsLoading extends EducationServiceDetailsState {}

class EducationServiceDetailsLoaded extends EducationServiceDetailsState {
  final EducationServiceDetailsModel service;

  EducationServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class EducationServiceDetailsError extends EducationServiceDetailsState {
  final String message;

  EducationServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
