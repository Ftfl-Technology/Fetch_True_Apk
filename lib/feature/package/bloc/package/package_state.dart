import 'package:equatable/equatable.dart';
import '../../model/package_model.dart';

abstract class PackageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<PackageModel> packages;

  PackageLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class PackageError extends PackageState {
  final String error;

  PackageError(this.error);

  @override
  List<Object?> get props => [error];
}
