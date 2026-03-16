import 'package:equatable/equatable.dart';
import '../../model/extra_service_model.dart';

abstract class ExtraServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExtraServiceInitial extends ExtraServiceState {}

class ExtraServiceLoading extends ExtraServiceState {}

class ExtraServiceLoaded extends ExtraServiceState {
  final List<ExtraServiceModel> services;
  final bool isAdminApproved;

  ExtraServiceLoaded({
    required this.services,
    required this.isAdminApproved,
  });

  @override
  List<Object?> get props => [services, isAdminApproved];
}

class ExtraServiceError extends ExtraServiceState {
  final String message;

  ExtraServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
