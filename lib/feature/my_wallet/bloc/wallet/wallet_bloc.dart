import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc(this.walletRepository) : super(WalletInitial()) {
    on<FetchWalletByUserId>(_onFetchWallet);
  }

  Future<void> _onFetchWallet(
      FetchWalletByUserId event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoading());
    try {
      final wallet = await walletRepository.getWallet(event.userId);
      if (wallet != null) {
        emit(WalletLoaded(wallet));
      } else {
        emit(const WalletError("Wallet data not found"));
      }
    } catch (e) {
      emit(WalletError("Failed to fetch wallet: $e"));
    }
  }
}
