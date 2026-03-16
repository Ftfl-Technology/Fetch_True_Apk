import 'package:equatable/equatable.dart';


abstract class ItPopularServiceEvent extends Equatable {
  const ItPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchItPopularServices extends ItPopularServiceEvent {
  final String moduleId;

  const FetchItPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
