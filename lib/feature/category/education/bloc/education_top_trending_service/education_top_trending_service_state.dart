import 'package:equatable/equatable.dart';
import '../../model/education_top_trending_service_model.dart';


abstract class EducationTopTrendingServiceState extends Equatable {
  const EducationTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class EducationTopTrendingServiceInitial
    extends EducationTopTrendingServiceState {}

class EducationTopTrendingServiceLoading
    extends EducationTopTrendingServiceState {}

class EducationTopTrendingServiceLoaded
    extends EducationTopTrendingServiceState {
  final EducationTopTrendingServiceModel data;

  const EducationTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class EducationTopTrendingServiceError
    extends EducationTopTrendingServiceState {
  final String message;

  const EducationTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
