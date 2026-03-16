import 'package:equatable/equatable.dart';


abstract class EducationPopularServiceEvent extends Equatable {
  const EducationPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchEducationPopularServices extends EducationPopularServiceEvent {
  final String moduleId;

  const FetchEducationPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
