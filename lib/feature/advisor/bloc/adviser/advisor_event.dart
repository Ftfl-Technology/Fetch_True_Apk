import 'package:equatable/equatable.dart';
abstract class AdvisorEvent extends Equatable {
  const AdvisorEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdvisors extends AdvisorEvent {
  const FetchAdvisors();
}