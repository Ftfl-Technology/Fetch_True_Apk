import 'package:equatable/equatable.dart';
import '../model/add_model.dart';

abstract class AdsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsLoaded extends AdsState {
  final List<AdsModel> ads;
  AdsLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class AdsError extends AdsState {
  final String message;
  AdsError(this.message);

  @override
  List<Object?> get props => [message];
}
