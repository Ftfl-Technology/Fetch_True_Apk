import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_by_user_coupon_repository.dart';
import 'user_by_user_coupon_event.dart';
import 'user_by_user_coupon_state.dart';

class UserByUserCouponBloc extends Bloc<UserByUserCouponEvent, UserByUserCouponState> {
  final UserByUserCouponRepository repository;

  UserByUserCouponBloc(this.repository) : super(UserByUserCouponInitial()) {
    on<FetchUserByUserCoupons>(_onFetchUserByUserCoupons);
  }

  Future<void> _onFetchUserByUserCoupons(
      FetchUserByUserCoupons event,
      Emitter<UserByUserCouponState> emit,
      ) async {
    emit(UserByUserCouponLoading());
    try {
      final coupons = await repository.getUsedByUserCoupons(event.userId);
      emit(UserByUserCouponLoaded(coupons));
    } catch (e) {
      emit(UserByUserCouponError(e.toString()));
    }
  }
}