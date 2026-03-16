import 'package:equatable/equatable.dart';

abstract class PackageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPackages extends PackageEvent {}
