import 'package:equatable/equatable.dart';


abstract class BusinessPopularServiceEvent extends Equatable {
  const BusinessPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessPopularServices extends BusinessPopularServiceEvent {
  final String moduleId;

  const FetchBusinessPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
