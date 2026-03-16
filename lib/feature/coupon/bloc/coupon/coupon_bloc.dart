import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/coupon_repository.dart';
import 'coupon_event.dart';
import 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final CouponRepository repository;

  CouponBloc(this.repository) : super(CouponInitial()) {
    on<FetchCouponsEvent>(_onFetchCoupons);
  }

  Future<void> _onFetchCoupons(
      FetchCouponsEvent event,
      Emitter<CouponState> emit,
      ) async {
    emit(CouponLoading());

    try {
      final coupons = await repository.fetchCouponsByUser(
        userId: event.userId,
        serviceId: event.serviceId,
        lat: event.lat,
        lng: event.lng,
      );

      emit(CouponLoaded(coupons));
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }
}
