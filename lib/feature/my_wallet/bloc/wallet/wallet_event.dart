import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class FetchWalletByUserId extends WalletEvent {
  final String userId;

  const FetchWalletByUserId(this.userId);

  @override
  List<Object?> get props => [userId];
}
