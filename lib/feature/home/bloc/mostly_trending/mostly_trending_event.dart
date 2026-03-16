import 'package:equatable/equatable.dart';

abstract class MostlyTrendingEvent extends Equatable {
  const MostlyTrendingEvent();

  @override
  List<Object?> get props => [];
}

class FetchMostlyTrending extends MostlyTrendingEvent {}
