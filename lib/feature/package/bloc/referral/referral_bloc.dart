import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/referral_repository.dart';
import 'referral_event.dart';
import 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final ReferralRepository repository;

  ReferralBloc(this.repository) : super(ReferralInitial()) {
    on<LoadReferrals>((event, emit) async {
      emit(ReferralLoading());
      try {
        final referrals = await repository.fetchReferrals(event.userId);
        emit(ReferralLoaded(referrals));
      } catch (e) {
        emit(ReferralError(e.toString()));
      }
    });
  }
}
