// bloc/service_event.dart
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetServices extends ServiceEvent {}
