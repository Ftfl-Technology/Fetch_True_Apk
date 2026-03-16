import 'package:equatable/equatable.dart';

abstract class WhyJustOurServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetWhyJustOurServiceEvent extends WhyJustOurServiceEvent {
  final String moduleId;

  GetWhyJustOurServiceEvent(this.moduleId);

  @override
  List<Object?> get props => [moduleId];
}
