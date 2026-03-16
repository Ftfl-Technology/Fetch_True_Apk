import 'package:equatable/equatable.dart';

abstract class EducationServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEducationServiceDetails extends EducationServiceDetailsEvent {
  final String serviceId;

  FetchEducationServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
