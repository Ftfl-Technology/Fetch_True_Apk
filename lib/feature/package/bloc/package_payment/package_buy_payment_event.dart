import 'package:equatable/equatable.dart';

import '../../model/package_buy_payment_model.dart';

abstract class PackagePaymentEvent extends Equatable {
  const PackagePaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentLinkEvent extends PackagePaymentEvent {
  final PackageBuyPaymentModel paymentModel;

  const CreatePaymentLinkEvent(this.paymentModel);

  @override
  List<Object?> get props => [paymentModel];
}
