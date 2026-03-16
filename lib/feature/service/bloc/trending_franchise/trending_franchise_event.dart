import 'package:equatable/equatable.dart';

abstract class FranchiseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFranchises extends FranchiseEvent {}
