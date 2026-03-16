import 'package:equatable/equatable.dart';
import '../model/offer_model.dart';

abstract class OfferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<OfferModel> offers;
  OfferLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class OfferError extends OfferState {
  final String message;
  OfferError(this.message);

  @override
  List<Object?> get props => [message];
}
