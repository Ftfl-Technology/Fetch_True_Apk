// import 'package:fetchtrue/feature/team_build/bloc/user_referral/user_referral_event.dart';
// import 'package:fetchtrue/feature/team_build/bloc/user_referral/user_referral_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../repository/user_referral_repository.dart';
//
// class UserReferralBloc extends Bloc<UserReferralEvent, UserReferralState> {
//   final UserReferralRepository repository;
//
//   UserReferralBloc(this.repository) : super(UserReferralInitial()) {
//     on<FetchUserByReferralCode>((event, emit) async {
//       emit(UserReferralLoading());
//       try {
//         final user = await repository.getUserByReferralCode(event.referralCode);
//         emit(UserReferralLoaded(user));
//       } catch (e) {
//         emit(UserReferralError(e.toString()));
//       }
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_referral_repository.dart';
import 'user_referral_event.dart';
import 'user_referral_state.dart';

class UserReferralBloc extends Bloc<UserReferralEvent, UserReferralState> {
  final UserReferralRepository repository;

  UserReferralBloc(this.repository) : super(UserReferralInitial()) {
    // Fetch user by referral code
    on<FetchUserByReferralCode>((event, emit) async {
      emit(UserReferralLoading());
      try {
        final user = await repository.getUserByReferralCode(event.referralCode);
        emit(UserReferralLoaded(user));
      } catch (e) {
        emit(UserReferralError(e.toString()));
      }
    });
  }
}

