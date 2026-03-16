import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';
import '../bloc/payu_gateway/payu_gateway_bloc.dart';
import '../model/checkout_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/payu_gateway_model.dart';
import '../screen/payu_open_in_app_view_screen.dart';
import '../../profile/model/user_model.dart';


class PaymentStep extends StatefulWidget {
  final UserModel user;
  final CheckOutModel checkoutModel;
  final Function(CheckOutModel) onPaySuccess;

  const PaymentStep({
    super.key,
    required this.checkoutModel,
    required this.onPaySuccess,
    required this.user,
  });


  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep>
    with TickerProviderStateMixin {

  CheckOutModel? _checkoutSuccessModel;


  bool useWallet = false;

  String? selectedPayment;
  String? cashfreeType;


  int get payableAmount => (widget.checkoutModel.grandTotal ?? 0).round();

  int get partialAmount => (payableAmount / 2).round();


  CheckOutModel updatedCheckoutModel() {
    final bool isCashfree = selectedPayment == 'cashfree';
    final bool isPartial = isCashfree && cashfreeType == 'partial';

    final num paidAmount =
    isPartial ? partialAmount : payableAmount;

    final num remainingAmount = (widget.checkoutModel.grandTotal ?? 0) - paidAmount;

    return widget.checkoutModel.copyWith(
      paymentMethod: [selectedPayment!],
      cashfreeMethod: isCashfree ? cashfreeType : null,
      isPartialPayment: isPartial,
      // paidAmount: paidAmount,
      paidAmount: 0,
      remainingAmount: isPartial ? remainingAmount : 0,
      walletAmount: 0,
      otherAmount: paidAmount,
      orderStatus: 'processing',
      paymentStatus: 'pending',
      termsCondition: true,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total Price',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 10),
              Text(
                '\u20B9 ${widget.checkoutModel.totalAmount}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(height: 20),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Choose Payment Method',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              CustomContainer(
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cashfree Pay',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Radio<String>(
                          value: 'cashfree',
                          groupValue: selectedPayment,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value;
                              cashfreeType = null; // reset
                            });
                          },
                        ),
                      ],
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: selectedPayment == 'cashfree'
                          ? SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: 'full',
                                groupValue: cashfreeType,
                                activeColor: Colors.green,
                                title: Text(
                                  '\u20B9 ${payableAmount}',
                                  style: TextStyle(
                                    color: CustomColor.appColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Full Payment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    cashfreeType = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: 'partial',
                                groupValue: cashfreeType,
                                activeColor: Colors.green,
                                title: Text(
                                  '\u20B9 ${partialAmount}',
                                  style: TextStyle(
                                    color: CustomColor.appColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Partial Payment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    cashfreeType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(height: 0),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment after Consultation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Radio<String>(
                          value: 'pac',
                          groupValue: selectedPayment,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value;
                              cashfreeType = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),

          Spacer(),
          BlocListener<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutSuccess) {
                 _checkoutSuccessModel  = state.model;

                if (state.model.paymentMethod?.first == 'pac') {
                  widget.onPaySuccess(state.model);

                  context.read<LeadBloc>().add(FetchLeadsByUser(state.model.user.toString()),);
                  return;
                }


                 if (state.model.paymentMethod?.first == 'cashfree') {
                  final timestamp = DateTime.now().millisecondsSinceEpoch;
                  final orderId = "checkout_$timestamp";

                  final subAmount = cashfreeType == 'partial' ? partialAmount : payableAmount;

                  final payuModel = PayUGatewayModel(

                    subAmount: subAmount,
                    // subAmount: widget.checkoutModel.grandTotal!.toInt(),
                    isPartialPaymentAllowed: false,
                    description: "Service Payment",
                    orderId: orderId,
                    customer: PayUCustomer(
                      customerId: widget.user.id,
                      customerName: widget.user.fullName,
                      customerEmail: widget.user.email,
                      customerPhone: widget.user.mobileNumber,
                    ),
                    udf: PayUUdf(
                      udf1: orderId,
                      udf2: _checkoutSuccessModel!.id.toString(),
                      // udf2: widget.checkoutModel.id.toString(),
                      udf3: widget.user.id,
                    ),
                  );

                  context.read<PayUGatewayBloc>().add(CreatePayULinkEvent(payuModel),);
                }
              }

              if (state is CheckoutFailure) {
                showCustomToast(state.error);
              }
            },
            child: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                final bool isLoading = state is CheckoutLoading;

                return BlocListener<PayUGatewayBloc, PayUGatewayState>(
                  listener: (context, state) {
                    if (state is PayUGatewaySuccess) {
                      final paymentUrl = state.response.result?.paymentLink;

                      if (paymentUrl != null && paymentUrl.isNotEmpty) {

                        final updatedModel = _checkoutSuccessModel ?? updatedCheckoutModel();

                        openInAppWebView(
                          context,
                          paymentUrl,
                              () {
                            widget.onPaySuccess(updatedModel);

                            context.read<LeadBloc>().add(
                              FetchLeadsByUser(updatedModel.user.toString()),
                            );
                          },
                        );
                      }
                    }
                    else if (state is PayUGatewayFailure) {
                      print('Payment failed: ${state.message}');
                      showCustomToast('Payment failed: ${state.message}');
                    }
                  },
                  child: CustomContainer(
                    color: isLoading
                        ? CustomColor.appColor.withOpacity(0.6)
                        : CustomColor.appColor,
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, valueColor: AlwaysStoppedAnimation<
                            Color>(Colors.white),),)
                          : const Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: isLoading
                        ? null
                        : () {
                      if (selectedPayment == null) {
                        showCustomToast(
                            'Please select payment method');
                        return;
                      }

                      if (selectedPayment == 'cashfree' && cashfreeType == null) {
                        showCustomToast('Please select full or partial payment');
                        return;
                      }

                      final updatedModel = updatedCheckoutModel();

                      debugPrint("FINAL CHECKOUT MODEL:");
                      debugPrint(updatedModel.toJson().toString());
                      context.read<CheckoutBloc>().add(CheckoutRequestEvent(updatedModel),);
                      },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
