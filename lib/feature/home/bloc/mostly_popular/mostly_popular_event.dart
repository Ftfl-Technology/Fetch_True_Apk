import 'package:equatable/equatable.dart';

abstract class MostlyPopularEvent extends Equatable {
  const MostlyPopularEvent();

  @override
  List<Object?> get props => [];
}

class FetchMostlyPopular extends MostlyPopularEvent {}
