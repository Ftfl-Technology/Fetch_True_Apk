import 'package:equatable/equatable.dart';
import '../../model/bank_kyc_model.dart';

abstract class BankKycEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitBankKycEvent extends BankKycEvent {
  final BankKycModel bankKyc;

  SubmitBankKycEvent(this.bankKyc);

  @override
  List<Object?> get props => [bankKyc];
}
