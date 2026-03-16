import 'package:equatable/equatable.dart';


abstract class EducationTopTrendingServiceEvent extends Equatable {
  const EducationTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchEducationTopTrendingServices extends EducationTopTrendingServiceEvent {
  final String moduleId;

  const FetchEducationTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
