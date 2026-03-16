// user_confirm_referral_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_referral_repository.dart';
import 'user_confirm_referral_event.dart';
import 'user_confirm_referral_state.dart';

class UserConfirmReferralBloc
    extends Bloc<UserConfirmReferralEvent, UserConfirmReferralState> {
  final UserReferralRepository repository;

  UserConfirmReferralBloc(this.repository)
      : super(UserConfirmReferralInitial()) {
    on<ConfirmReferralCodeEvent>(_onConfirmReferralCode);
  }

  Future<void> _onConfirmReferralCode(
      ConfirmReferralCodeEvent event,
      Emitter<UserConfirmReferralState> emit,
      ) async {
    emit(UserConfirmReferralLoading());

    try {
      final success = await repository.confirmReferralCode(
        userId: event.userId,
        referralCode: event.referralCode,
      );

      if (success) {
        emit(UserConfirmReferralLoaded());
      } else {
        emit(UserConfirmReferralError("Referral confirmation failed"));
      }
    } catch (e) {
      emit(UserConfirmReferralError(e.toString()));
    }
  }
}
