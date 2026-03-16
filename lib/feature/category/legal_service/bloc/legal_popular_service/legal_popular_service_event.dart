import 'package:equatable/equatable.dart';


abstract class LegalPopularServiceEvent extends Equatable {
  const LegalPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchLegalPopularServices extends LegalPopularServiceEvent {
  final String moduleId;

  const FetchLegalPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
