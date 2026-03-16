import 'package:equatable/equatable.dart';

abstract class BankDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBankDetailEvent extends BankDetailEvent {
  final String userId;

  FetchBankDetailEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
