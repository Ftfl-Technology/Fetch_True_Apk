import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bank_detail_repository.dart';
import 'bank_detail_event.dart';
import 'bank_detail_state.dart';

class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  final BankDetailRepository repository;

  BankDetailBloc(this.repository) : super(BankDetailInitial()) {
    on<FetchBankDetailEvent>(_onFetchBankDetail);
  }

  Future<void> _onFetchBankDetail(
      FetchBankDetailEvent event, Emitter<BankDetailState> emit) async {
    emit(BankDetailLoading());
    try {
      final detail = await repository.fetchBankDetail(event.userId);
      emit(BankDetailLoaded(detail));
    } catch (e) {
      emit(BankDetailError(e.toString()));
    }
  }
}
