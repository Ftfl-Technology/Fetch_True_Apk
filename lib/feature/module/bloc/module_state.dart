import 'package:equatable/equatable.dart';
import 'package:fetchtrue/feature/module/model/module_model.dart';

abstract class ModuleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ModuleInitial extends ModuleState {}
class ModuleLoading extends ModuleState {}
class ModuleLoaded extends ModuleState {
  final List<ModuleModel> modules;
  ModuleLoaded(this.modules);

  @override
  List<Object?> get props => [modules];
}
class ModuleError extends ModuleState {
  final String message;
  ModuleError(this.message);

  @override
  List<Object?> get props => [message];
}
