import 'package:equatable/equatable.dart';
import '../../model/address_model.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddOrUpdateAddressEvent extends AddressEvent {
  final String userId;
  final AddressModel addressModel;

  AddOrUpdateAddressEvent({required this.userId, required this.addressModel});

  @override
  List<Object?> get props => [userId, addressModel];
}
