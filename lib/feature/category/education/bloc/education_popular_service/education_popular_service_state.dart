import 'package:equatable/equatable.dart';
import '../../model/education_popular_service_model.dart';

abstract class EducationPopularServiceState extends Equatable {
  const EducationPopularServiceState();

  @override
  List<Object> get props => [];
}

class EducationPopularServiceInitial
    extends EducationPopularServiceState {}

class EducationPopularServiceLoading
    extends EducationPopularServiceState {}

class EducationPopularServiceLoaded
    extends EducationPopularServiceState {
  final EducationPopularServiceModel data;

  const EducationPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class EducationPopularServiceError
    extends EducationPopularServiceState {
  final String message;

  const EducationPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
