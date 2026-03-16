import 'package:equatable/equatable.dart';

import '../../model/bank_detail_model.dart';

abstract class BankDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankDetailInitial extends BankDetailState {}

class BankDetailLoading extends BankDetailState {}

class BankDetailLoaded extends BankDetailState {
  final BankDetailModel bankDetail;

  BankDetailLoaded(this.bankDetail);

  @override
  List<Object?> get props => [bankDetail];
}

class BankDetailError extends BankDetailState {
  final String message;

  BankDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
