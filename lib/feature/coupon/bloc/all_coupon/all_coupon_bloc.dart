import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/all_coupon_repository.dart';
import 'all_coupon_event.dart';
import 'all_coupon_state.dart';

class AllCouponBloc extends Bloc<AllCouponEvent, AllCouponState> {
  final AllCouponRepository repository;

  AllCouponBloc({required this.repository}) : super(AllCouponInitial()) {
    on<FetchAllCoupons>(_onFetchAllCoupons);
  }

  Future<void> _onFetchAllCoupons(
      FetchAllCoupons event, Emitter<AllCouponState> emit) async {
    emit(AllCouponLoading());
    try {
      final coupons = await repository.getAllCoupons();
      emit(AllCouponLoaded(coupons));
    } catch (e) {
      emit(AllCouponError(e.toString()));
    }
  }
}