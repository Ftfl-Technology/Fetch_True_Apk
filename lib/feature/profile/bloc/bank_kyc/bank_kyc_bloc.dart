import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bank_kyc_repository.dart';
import 'bank_kyc_event.dart';
import 'bank_kyc_state.dart';

class BankKycBloc extends Bloc<BankKycEvent, BankKycState> {
  final BankKycRepository repository;

  BankKycBloc(this.repository) : super(BankKycInitial()) {
    on<SubmitBankKycEvent>(_onSubmitBankKyc);
  }

  Future<void> _onSubmitBankKyc(
      SubmitBankKycEvent event, Emitter<BankKycState> emit) async {
    emit(BankKycLoading());
    try {
      final response = await repository.submitBankKyc(event.bankKyc);
      if (response.statusCode == 200) {
        emit(BankKycSuccess(response.data));
      } else {
        emit(BankKycError(
            response.data['cashfreeResponse']?['message'] ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(BankKycError(e.toString()));
    }
  }
}
