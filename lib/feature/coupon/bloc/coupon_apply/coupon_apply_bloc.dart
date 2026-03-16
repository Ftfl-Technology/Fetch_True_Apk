import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/coupon_apply_repository.dart';
import 'coupon_apply_event.dart';
import 'coupon_apply_state.dart';

class CouponApplyBloc extends Bloc<CouponApplyEvent, CouponApplyState> {
  final CouponApplyRepository repository;

  CouponApplyBloc(this.repository) : super(CouponApplyInitial()) {
    on<ApplyCouponEvent>(_onApplyCoupon);
  }

  Future<void> _onApplyCoupon(
      ApplyCouponEvent event, Emitter<CouponApplyState> emit) async {
    emit(CouponApplyLoading());
    try {
      final response = await repository.applyCoupon(event.couponModel);
      if (response.success) {
        emit(CouponApplySuccess(response));
      } else {
        emit(const CouponApplyFailure("Invalid Coupon"));
      }
    } catch (e) {
      emit(CouponApplyFailure(e.toString()));
    }
  }
}
