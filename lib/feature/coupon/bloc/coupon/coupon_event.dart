import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object?> get props => [];
}

class FetchCouponsEvent extends CouponEvent {
  final String userId;
  final String serviceId;
  final double lat;
  final double lng;

  const FetchCouponsEvent({
    required this.userId,
    required this.serviceId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [userId, serviceId, lat, lng];
}
