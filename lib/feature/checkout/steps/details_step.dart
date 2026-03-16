import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/feature/customer/screen/customer_screen.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../coupon/model/coupon_model.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../customer/bloc/customer/customer_bloc.dart';
import '../../customer/repository/customer_repository.dart';
import '../../customer/screen/add_customer_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/model/user_model.dart';
import '../../provider/model/service_wise_provider_subscriber_model.dart';
import '../model/checkout_model.dart';
import '../model/commission_model.dart';
import '../screen/check_out_screen.dart';



final GlobalKey<_DetailsStepState> detailsKey = GlobalKey<_DetailsStepState>();


class DetailsStep extends StatefulWidget {
  final UserModel user;
  final ProviderSubscriberModel? provider;
  final SelectedServiceData serviceData;
  final CommissionModel commissionCharge;
  // final VoidCallback onProceed;
  final Function(CheckOutModel model) onProceed;

  const DetailsStep({
    super.key,
    required this.user,
    this.provider,
    required this.serviceData,
    required this.commissionCharge,
    required this.onProceed,
  });
  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> with TickerProviderStateMixin {
  int currentStep = 0;
  void goToPayment() {
    setState(() {
      currentStep = 1;
    });
  }


  bool _isCheckbox = false;

  CheckOutModel? buildCheckoutModel() {
    if (!_isCheckbox) {
      showCustomToast('Please agree to Terms & Conditions');
      return null;
    }

    final serviceUserId = selectedServiceUserId;
    final serviceType = selectedServiceType;

    if (serviceUserId == null || serviceType == 'NONE') {
      showCustomToast('Please select service for you or customer');
      return null;
    }


    return CheckOutModel(
        id: widget.serviceData.serviceId,
        user: widget.user.id,
        service: widget.serviceData.serviceId,
        provider: widget.provider?.id,
        serviceCustomer: serviceUserId,
        coupon: selectedCoupon?.couponId,
        listingPrice: listingPrice.round(),
        serviceDiscountPrice: serviceDiscountAmount.round(),
        priceAfterDiscount: priceAfterDiscount.round(),
        couponDiscountPrice: couponDiscountAmount.round(),
        serviceGSTPrice: gstAmount.round(),
        platformFeePrice: platformFee.round(),
        assurityChargesPrice: assurityFeeAmount.round(),
        subtotal: listingPrice.round(),
        totalAmount: grandTotal.round(),
        grandTotal: grandTotal.round(),
        paidAmount: grandTotal.round(),
        isPartialPayment: false,
        termsCondition: _isCheckbox,
        notes: message.toString(),
        commission: widget.serviceData.earnUpTo,
        serviceDiscount: num.tryParse(widget.serviceData.discount) ?? 0,
        couponDiscount: double.parse((selectedCoupon?.amount.toDouble() ?? 0.0).toStringAsFixed(2)),
        couponDiscountType: selectedCoupon?.discountAmountType == 'Percentage' ? '%' : '₹',
        gst: num.tryParse(widget.serviceData.serviceGST) ?? 0,
        platformFee: widget.commissionCharge.platformFee,
        assurityfee: widget.commissionCharge.assurityFee,
        champaignDiscount: 0.0,
    );
  }


  bool? serviceFor;

  String? customer_Id;
  String? customerId;
  String? customerName;
  String? customerPhone;
  String? message;

  CouponModel? selectedCoupon;


// Base price
  double get listingPrice =>
      double.tryParse(widget.serviceData.price.toString()) ?? 0;

// Discount %
  double get serviceDiscountPercent =>
      double.tryParse(widget.serviceData.discount.toString()) ?? 0;

// Discount amount
  double get serviceDiscountAmount =>
      (listingPrice * serviceDiscountPercent) / 100;

// Price after service discount
  double get priceAfterDiscount =>
      listingPrice - serviceDiscountAmount;

// Coupon discount
  double get couponDiscountAmount {
    if (selectedCoupon == null) return 0;

    final couponValue =
        double.tryParse(selectedCoupon!.amount.toString()) ?? 0;

    if (selectedCoupon!.discountAmountType == 'Percentage') {
      return (priceAfterDiscount * couponValue) / 100;
    } else {
      return couponValue;
    }
  }

// GST
  double get gstAmount {
    final gst =
        double.tryParse(widget.serviceData.serviceGST.toString()) ?? 0;
    return (priceAfterDiscount * gst) / 100;
  }

// Platform fee (flat)
  double get platformFee =>
      double.tryParse(widget.commissionCharge.platformFee.toString()) ?? 0;

// Assurity fee (%)
  double get assurityFeeAmount {
    final assurity =
        double.tryParse(widget.commissionCharge.assurityFee.toString()) ?? 0;
    return (priceAfterDiscount * assurity) / 100;
  }

// Grand total
  double get grandTotal =>
      priceAfterDiscount -
          couponDiscountAmount +
          gstAmount +
          platformFee +
          assurityFeeAmount;


  // ================= FINAL SELECTION LOGIC =================

  String? get selectedServiceUserId {
    if (serviceFor == true) {
      return widget.user.id;
    }

    if (serviceFor == false && customer_Id != null && customer_Id!.isNotEmpty) {
      return customer_Id;
    }

    return null;
  }

  String get selectedServiceType {
    if (serviceFor == true) return 'SELF';
    if (serviceFor == false) return 'CUSTOMER';
    return 'NONE';
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 15,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomContainer(
                            color: Colors.grey.shade200,
                            height: 100,width: 150,
                            margin: EdgeInsets.zero,
                            networkImg: '${widget.serviceData.serviceThumbnail}',
                          ),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.height,
                                Text('${widget.serviceData.serviceName}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                Row(
                                  spacing: 5,
                                  children: [
                                    Text('${widget.serviceData.categoryName}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
                                    Text('${CustomLogEmoji.star} ${widget.serviceData.rating}', style: TextStyle(fontSize: 12, color: Colors.grey),)
                                  ],
                                ),
                                10.height,
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      '${widget.serviceData.discount}% OFF',
                                      style: TextStyle(fontSize: 10, color: Colors.red),
                                    ),
                                    CustomAmountText(
                                      amount: double.parse(widget.serviceData.price)
                                          .toStringAsFixed(0), // removes .00
                                      isLineThrough: widget.serviceData.discountPrice != '0'? true: false,
                                      color: Colors.grey.shade700,
                                    ),
                            
                                    if(widget.serviceData.discountPrice != '0')
                                    CustomAmountText(
                                      amount: double.parse(widget.serviceData.discountPrice)
                                          .toStringAsFixed(0), // removes .00
                                      isLineThrough: false,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                            
                                5.height,
                              ],
                            ),
                          )
                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('EARN UP TO', style: TextStyle(fontSize: 14, color: CustomColor.appColor,fontWeight: FontWeight.w600),),
                            Text('${widget.serviceData.earnUpTo}', style: TextStyle(fontSize: 18, color: Colors.green,fontWeight: FontWeight.w600),),

                          ],
                        ),
                      ),


                      if (widget.provider != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text('Service Provider', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                              ),

                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  backgroundImage: (widget.provider!.storeInfo.logo != null &&
                                      widget.provider!.storeInfo.logo!.isNotEmpty)
                                      ? NetworkImage(widget.provider!.storeInfo.logo!)
                                      : AssetImage(CustomImage.nullImage)
                                  as ImageProvider,
                                ),
                                title: Text('Name: ${widget.provider!.storeInfo.storeName}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${widget.provider!.providerId}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),),
                                    Text('Phone: ${widget.provider!.storeInfo.storePhone}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),),

                                  ],
                                ),
                                trailing: Image.asset(CustomIcon.phoneIcon,height: 25,color: Colors.green,),
                              ),
                            ],
                          ),
                        ),

                    ],
                  ),
                ),

                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Who is this service for?',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                serviceFor = true;
                                debugPrint('For Me ${widget.user.id}');
                              });
                            },
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: serviceFor,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    setState(() {
                                      serviceFor = value;
                                      debugPrint('For Me ${widget.user.id}');
                                    });
                                  },
                                ),
                                const Text(
                                  'This service is for me',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topLeft,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: serviceFor  == true ? 1 : 0,
                              child:serviceFor == true
                                  ? Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade100,
                                    backgroundImage: (widget.user.profilePhoto != null &&
                                        widget.user.profilePhoto!.isNotEmpty)
                                        ? NetworkImage(widget.user.profilePhoto!)
                                        : AssetImage(CustomImage.nullImage)
                                    as ImageProvider,
                                  ),
                                  title: Text(
                                    'Name: ${widget.user.fullName}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone: ${widget.user.mobileNumber}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),

                                ),
                              )
                                  : const SizedBox(),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                serviceFor = false;
                                debugPrint('For Customer ${customer_Id}');
                              });
                            },
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: serviceFor,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    setState(() {
                                      serviceFor = value;
                                      debugPrint('For Customer ${customer_Id}');
                                    });
                                  },
                                ),
                                const Text(
                                  'This Service is for My Customer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topLeft,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: serviceFor == false  ? 1 : 0,
                              child: serviceFor == false
                                  ? Column(
                                children: [

                                  if(customerName!= null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 25.0),
                                      child: ListTile(
                                        // contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage: AssetImage(CustomImage.nullImage),
                                        ),
                                        title: Text(
                                          'Name: ${customerName}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Phone: ${customerPhone}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                            ),

                                            if (message != null && message!.isNotEmpty)
                                              Text(
                                                'Notes: ${message}',
                                                style: textStyle12(context, color: CustomColor.descriptionColor),
                                              ),
                                          ],
                                        ),
                                        trailing: Image.asset(CustomIcon.phoneIcon,height: 25,color: Colors.green,),
                                      ),
                                    ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: CustomColor.appColor, width: 1)
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Icon(Icons.account_circle_outlined,size: 16,color: CustomColor.appColor,),
                                              Text('Select Customer', style: TextStyle(fontSize: 12,color: CustomColor.appColor, fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                        ),

                                        onTap: () async {
                                          final selectedCustomer = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CustomerScreen(userId: widget.user.id,)),);
                                          if (selectedCustomer != null) {
                                            setState(() {
                                              customer_Id = selectedCustomer['_id'];
                                              customerId = selectedCustomer['userId'];
                                              customerName = selectedCustomer['fullName'];
                                              customerPhone = selectedCustomer['phone'];
                                              message = selectedCustomer['message'];
                                            });
                                          }
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerScreen(userId: '69428b99d6a7d5b63e92ec55',),));
                                        },

                                      ),

                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: CustomColor.whiteColor,
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: CustomColor.appColor, width: 1)
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Icon(Icons.account_circle_outlined,size: 16,color: CustomColor.appColor,),
                                              Text('Add Customer', style: TextStyle(fontSize: 12,color: CustomColor.appColor, fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          final selectedCustomer = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => BlocProvider(create: (_) => CustomerBloc(CustomerRepository()),
                                              child: AddCustomerScreen(userId: widget.user.id),
                                            ),
                                            ),
                                          );

                                          if (selectedCustomer != null) {
                                            setState(() {
                                              customer_Id = selectedCustomer['_id'];
                                              customerId = selectedCustomer['userId'];
                                              customerName = selectedCustomer['fullName'];
                                              customerPhone = selectedCustomer['phone'];
                                              message = selectedCustomer['message'];
                                            });
                                          }

                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )
                                  : const SizedBox(),
                            ),
                          ),

                          15.height,


                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _couponCard(context,
                        () async {
                      final selected = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CouponScreen(userId: widget.user.id,serviceId: widget.serviceData.serviceId,)),);
                      if (selected != null && selected is CouponModel) {
                        setState(() {
                          selectedCoupon = selected;
                        });
                      }
                    },
                    selectedCoupon,
                  ),
                ),


                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Payment Summary',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                      ),

                      _paymentSummery(
                        key: 'Listing Price',
                        value: '₹ ${listingPrice.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Service Discount (${widget.serviceData.discount}%)',
                        value: '- ₹ ${serviceDiscountAmount.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Price After Discount',
                        value: '₹ ${priceAfterDiscount.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Coupon Discount (${selectedCoupon != null ? '${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? ' %' : ' ₹'}' : '₹ 0'})',
                        value: '- ₹ ${couponDiscountAmount.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Service GST(${widget.serviceData.serviceGST}%)',
                        value: '+ ₹ ${gstAmount.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Platform Fee (${widget.commissionCharge.platformFee})',
                        value: '+ ₹ ${platformFee.toStringAsFixed(2)}',
                      ),

                      _paymentSummery(
                        key: 'Fetch True Assurity Charges (${widget.commissionCharge.assurityFee} %)',
                        value: '+ ₹ ${assurityFeeAmount.toStringAsFixed(2)}',
                      ),

                      10.height,
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFF5F8FF),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
                            Text('\u20B9 ${grandTotal.toStringAsFixed(2)}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                10.height


              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            final model  = buildCheckoutModel();
            if (model  != null) {
              widget.onProceed(model);
            }
          },

          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.green,
                    value: _isCheckbox,
                    onChanged: (value) {
                      setState(() {
                        _isCheckbox = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'I Agree with the terms & Condition',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              CustomContainer(
                color: CustomColor.appColor,
                child: Center(
                  child: Text("Proceed To Pay",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _couponCard(BuildContext context, VoidCallback? onTap, CouponModel? selectedCoupon) {
    final isPercentage = selectedCoupon?.discountAmountType == 'Percentage';

    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Best Coupon For You", style: textStyle12(context,)),
              InkWell(
                onTap: onTap,
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      selectedCoupon != null ? "Change Coupon" : "View Coupon",
                      style: textStyle12(context, color: CustomColor.appColor),
                    ),
                    Icon(Icons.arrow_forward_ios,size: 14, color: CustomColor.appColor,)
                  ],
                ),
              ),
            ],
          ),


          if (selectedCoupon != null)
            Column(
              children: [
                10.height,
                CustomContainer(
                  border: true,
                  color: Colors.transparent,
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${selectedCoupon.couponType}",
                        style: textStyle14(context, fontWeight: FontWeight.w500),
                      ),
                      5.height,
                      Text(
                        "Coupon Code: #${selectedCoupon.couponCode}",
                        style: textStyle12(context, color: CustomColor.greenColor),
                      ),
                      5.height,
                      Text(
                        "Offer: Save ${isPercentage ? '${selectedCoupon.amount}%' : '₹${selectedCoupon.amount}'}",
                        style: textStyle12(context, color: CustomColor.descriptionColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          // if (selectedCoupon == null)
          //   CustomContainer(
          //     border: true,
          //     color: Colors.transparent,
          //     margin: EdgeInsets.zero,
          //     // padding: EdgeInsets.zero,
          //     // child: Row(
          //     //   spacing: 10,
          //     //   children: [
          //     //     Expanded(
          //     //         flex: 2,
          //     //         child: DottedBorder(
          //     //           options: RoundedRectDottedBorderOptions(
          //     //             dashPattern: [6, 3],
          //     //             strokeWidth: 1,
          //     //             radius: Radius.circular(8),
          //     //             color: CustomColor.greyColor,
          //     //           ),
          //     //           child: CustomContainer(
          //     //             margin: EdgeInsets.zero,
          //     //             color: Colors.white,
          //     //             height: 45,
          //     //             padding: EdgeInsets.only(left: 20),
          //     //             child: TextField(
          //     //               style: textStyle12(context),
          //     //               decoration: InputDecoration(
          //     //                   hintText: '#XXXXXXX',
          //     //                   hintStyle: textStyle12(context, color: CustomColor.greyColor),
          //     //                   border: InputBorder.none
          //     //               ),
          //     //             ),
          //     //           ),
          //     //         )),
          //     //     Expanded(
          //     //       child: CustomContainer(
          //     //         margin: EdgeInsets.zero,
          //     //         child: Center(child: Text('Apply', style: textStyle14(context),)),
          //     //       ),
          //     //     )
          //     //   ],
          //     // ),
          //   ),
        ],
      ),
    );
  }

  Widget _paymentSummery({required String key, required String value}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${key}',style:  TextStyle(fontSize: 12, color: Colors.grey.shade700),),
          Text('${value}',style:  TextStyle(fontSize: 12, color: Colors.black),),
        ],
      ),
    );
  }
}

