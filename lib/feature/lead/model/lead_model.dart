class LeadResponse {
  final bool success;
  final List<LeadModel> data;

  LeadResponse({
    required this.success,
    required this.data,
  });

  factory LeadResponse.fromJson(Map<String, dynamic> json) {
    return LeadResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LeadModel.fromJson(e))
          .toList(),
    );
  }
}

class LeadModel {
  final String? id;
  final String? user;

  final Service? service;
  final ServiceCustomer? serviceCustomer;

  final dynamic provider;
  final dynamic serviceMan;
  final dynamic coupon;

  final num? subtotal;
  final num? serviceDiscount;
  final num? couponDiscount;
  final String? couponDiscountType;
  final num? champaignDiscount;
  final num? gst;
  final num? platformFee;
  final num? assurityfee;

  final num? listingPrice;
  final num? serviceDiscountPrice;
  final num? priceAfterDiscount;
  final num? couponDiscountPrice;
  final num? serviceGSTPrice;
  final num? platformFeePrice;
  final num? assurityChargesPrice;
  final num? extraServicePrice;

  final String? commission;

  final num? totalAmount;
  final num? grandTotal;

  final List<String> paymentMethod;

  final num? walletAmount;
  final num? otherAmount;
  final num? paidAmount;

  final bool? isPartialPayment;
  final num? remainingAmount;

  final String? cashfreeMethod;
  final String? paymentStatus;
  final String? orderStatus;

  final bool? cashInHand;
  final num? cashInHandAmount;

  final String? notes;

  final bool? termsCondition;
  final bool? isVerified;
  final bool? isAccepted;

  final String? acceptedDate;

  final bool? isOtpVerified;
  final bool? isCompleted;
  final bool? commissionDistributed;
  final bool? isCanceled;
  final bool? isDeleted;

  final String? createdAt;
  final String? updatedAt;

  final String? bookingId;
  final String? otp;
  final bool? isSkip;


  LeadModel({
    this.id,
    this.user,
    this.service,
    this.serviceCustomer,
    this.provider,
    this.serviceMan,
    this.coupon,
    this.subtotal,
    this.serviceDiscount,
    this.couponDiscount,
    this.couponDiscountType,
    this.champaignDiscount,
    this.gst,
    this.platformFee,
    this.assurityfee,
    this.listingPrice,
    this.serviceDiscountPrice,
    this.priceAfterDiscount,
    this.couponDiscountPrice,
    this.serviceGSTPrice,
    this.platformFeePrice,
    this.assurityChargesPrice,
    this.extraServicePrice,
    this.commission,
    this.totalAmount,
    this.grandTotal,
    required this.paymentMethod,
    this.walletAmount,
    this.otherAmount,
    this.paidAmount,
    this.isPartialPayment,
    this.remainingAmount,
    this.cashfreeMethod,
    this.paymentStatus,
    this.orderStatus,
    this.cashInHand,
    this.cashInHandAmount,
    this.notes,
    this.termsCondition,
    this.isVerified,
    this.isAccepted,
    this.acceptedDate,
    this.isOtpVerified,
    this.isCompleted,
    this.commissionDistributed,
    this.isCanceled,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.bookingId,
    this.otp,
    this.isSkip,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['_id'],
      user: json['user'],

      service:
      json['service'] != null ? Service.fromJson(json['service']) : null,

      serviceCustomer: json['serviceCustomer'] != null
          ? ServiceCustomer.fromJson(json['serviceCustomer'])
          : null,

      provider: json['provider'],
      serviceMan: json['serviceMan'],
      coupon: json['coupon'],

      subtotal: json['subtotal'],
      serviceDiscount: json['serviceDiscount'],
      couponDiscount: json['couponDiscount'],
      couponDiscountType: json['couponDiscountType'],
      champaignDiscount: json['champaignDiscount'],
      gst: json['gst'],
      platformFee: json['platformFee'],
      assurityfee: json['assurityfee'],

      listingPrice: json['listingPrice'],
      serviceDiscountPrice: json['serviceDiscountPrice'],
      priceAfterDiscount: json['priceAfterDiscount'],
      couponDiscountPrice: json['couponDiscountPrice'],
      serviceGSTPrice: json['serviceGSTPrice'],
      platformFeePrice: json['platformFeePrice'],
      assurityChargesPrice: json['assurityChargesPrice'],
      extraServicePrice: json['extraServicePrice'],

      commission: json['commission'],

      totalAmount: json['totalAmount'],
      grandTotal: json['grandTotal'],

      paymentMethod:
      (json['paymentMethod'] as List<dynamic>? ?? []).cast<String>(),

      walletAmount: json['walletAmount'],
      otherAmount: json['otherAmount'],
      paidAmount: json['paidAmount'],

      isPartialPayment: json['isPartialPayment'],
      remainingAmount: json['remainingAmount'],

      cashfreeMethod: json['cashfreeMethod'],
      paymentStatus: json['paymentStatus'],
      orderStatus: json['orderStatus'],

      cashInHand: json['cashInHand'],
      cashInHandAmount: json['cashInHandAmount'],

      notes: json['notes']?.toString(),

      termsCondition: json['termsCondition'],
      isVerified: json['isVerified'],
      isAccepted: json['isAccepted'],
      acceptedDate: json['acceptedDate'],

      isOtpVerified: json['isOtpVerified'],
      isCompleted: json['isCompleted'],
      commissionDistributed: json['commissionDistributed'],
      isCanceled: json['isCanceled'],
      isDeleted: json['isDeleted'],

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      bookingId: json['bookingId'],
      otp: json['otp'],
      isSkip: json['isSkip'] ?? false,
    );
  }
}

class Service {
  final String? id;
  final String? serviceName;
  final num? price;
  final num? discount;
  final num? discountedPrice;

  Service({
    this.id,
    this.serviceName,
    this.price,
    this.discount,
    this.discountedPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      serviceName: json['serviceName'],
      price: json['price'],
      discount: json['discount'],
      discountedPrice: json['discountedPrice'],
    );
  }
}

class ServiceCustomer {
  final String? id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? user;
  final String? customerId;
  final OtpStatus? otp;

  ServiceCustomer({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.description,
    this.address,
    this.city,
    this.state,
    this.country,
    this.user,
    this.customerId,
    this.otp,
  });

  factory ServiceCustomer.fromJson(Map<String, dynamic> json) {
    return ServiceCustomer(
      id: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      user: json['user'],
      customerId: json['customerId'],
      otp: json['otp'] != null ? OtpStatus.fromJson(json['otp']) : null,
    );
  }
}

class OtpStatus {
  final bool? verified;

  OtpStatus({this.verified});

  factory OtpStatus.fromJson(Map<String, dynamic> json) {
    return OtpStatus(
      verified: json['verified'],
    );
  }
}
