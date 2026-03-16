import 'package:equatable/equatable.dart';

abstract class ModuleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetModules extends ModuleEvent {}
