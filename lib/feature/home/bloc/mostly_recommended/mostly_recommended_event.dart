import 'package:equatable/equatable.dart';

abstract class MostlyRecommendedEvent extends Equatable {
  const MostlyRecommendedEvent();

  @override
  List<Object?> get props => [];
}

class FetchMostlyRecommended extends MostlyRecommendedEvent {}
