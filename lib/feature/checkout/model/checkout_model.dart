class CheckOutModel {
  final String? id;
  final String? user;
  final String? service;
  final String? serviceCustomer;
  final String? provider;
  final String? serviceMan;
  final String? coupon;

  final num? subtotal;
  final num? serviceDiscount;
  final num? couponDiscount;
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
  final String? couponDiscountType;
  final num? totalAmount;
  final num? grandTotal;

  final List<String>? paymentMethod;
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
  final String? otp;
  final String? bookingId;


  CheckOutModel({
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
     this.couponDiscountType,
     this.totalAmount,
     this.grandTotal,
     this.paymentMethod,
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
     this.otp,
    this.bookingId,
  });


  factory CheckOutModel.fromJson(Map<String, dynamic> json) {
    return CheckOutModel(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      service: json['service'] ?? "",
      serviceCustomer: json['serviceCustomer'],
      provider: json["provider"],
      serviceMan: json["serviceMan"],
      coupon: json["coupon"],
      subtotal: json["subtotal"] ?? 0,
      serviceDiscount: json["serviceDiscount"] ?? 0,
      couponDiscount: json["couponDiscount"] ?? 0,
      champaignDiscount: json["champaignDiscount"] ?? 0,
      gst: json["gst"] ?? 0,
      platformFee: json["platformFee"] ?? 0,
      assurityfee: json["assurityfee"] ?? 0,
      listingPrice: json["listingPrice"] ?? 0,
      serviceDiscountPrice: json["serviceDiscountPrice"] ?? 0,
      priceAfterDiscount: json["priceAfterDiscount"] ?? 0,
      couponDiscountPrice: json["couponDiscountPrice"] ?? 0,
      serviceGSTPrice: json["serviceGSTPrice"] ?? 0,
      platformFeePrice: json["platformFeePrice"] ?? 0,
      assurityChargesPrice: json["assurityChargesPrice"] ?? 0,
      extraServicePrice: json["extraServicePrice"] ?? 0,
      commission: json["commission"] ?? "",
      couponDiscountType: json["couponDiscountType"] ?? "",
      totalAmount: json["totalAmount"] ?? 0,
      grandTotal: json["grandTotal"] ?? 0,
      paymentMethod: List<String>.from(json["paymentMethod"] ?? []),
      walletAmount: json["walletAmount"] ?? 0,
      otherAmount: json["otherAmount"] ?? 0,
      paidAmount: json["paidAmount"] ?? 0,
      isPartialPayment: json["isPartialPayment"] ?? false,
      remainingAmount: json["remainingAmount"] ?? 0,
      cashfreeMethod: json["cashfreeMethod"],
      paymentStatus: json["paymentStatus"] ?? "",
      orderStatus: json["orderStatus"] ?? "",
      cashInHand: json["cashInHand"] ?? false,
      cashInHandAmount: json["cashInHandAmount"] ?? 0,
      notes: json["notes"] ?? "",
      termsCondition: json["termsCondition"] ?? false,
      isVerified: json["isVerified"] ?? false,
      isAccepted: json["isAccepted"] ?? false,
      acceptedDate: json["acceptedDate"],
      isOtpVerified: json["isOtpVerified"] ?? false,
      isCompleted: json["isCompleted"] ?? false,
      commissionDistributed: json["commissionDistributed"] ?? false,
      isCanceled: json["isCanceled"] ?? false,
      isDeleted: json["isDeleted"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      otp: json["otp"] ?? "",
      bookingId: json['bookingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user,
      "service": service,
      "serviceCustomer": serviceCustomer,
      "provider": provider,
      "serviceMan": serviceMan,
      "coupon": coupon,
      "subtotal": subtotal,
      "serviceDiscount": serviceDiscount,
      "couponDiscount": couponDiscount,
      "champaignDiscount": champaignDiscount,
      "gst": gst,
      "platformFee": platformFee,
      "assurityfee": assurityfee,
      "listingPrice": listingPrice,
      "serviceDiscountPrice": serviceDiscountPrice,
      "priceAfterDiscount": priceAfterDiscount,
      "couponDiscountPrice": couponDiscountPrice,
      "serviceGSTPrice": serviceGSTPrice,
      "platformFeePrice": platformFeePrice,
      "assurityChargesPrice": assurityChargesPrice,
      "extraServicePrice": extraServicePrice,
      "commission": commission,
      "couponDiscountType": couponDiscountType,
      "totalAmount": totalAmount,
      "grandTotal": grandTotal,
      "paymentMethod": paymentMethod,
      "walletAmount": walletAmount,
      "otherAmount": otherAmount,
      "paidAmount": paidAmount,
      "isPartialPayment": isPartialPayment,
      "remainingAmount": remainingAmount,
      "cashfreeMethod": cashfreeMethod,
      "paymentStatus": paymentStatus,
      "orderStatus": orderStatus,
      "cashInHand": cashInHand,
      "cashInHandAmount": cashInHandAmount,
      "notes": notes,
      "termsCondition": termsCondition,
      "isVerified": isVerified,
      "isAccepted": isAccepted,
      "acceptedDate": acceptedDate,
      "isOtpVerified": isOtpVerified,
      "isCompleted": isCompleted,
      "commissionDistributed": commissionDistributed,
      "isCanceled": isCanceled,
      "isDeleted": isDeleted,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "otp": otp,
      'bookingId': bookingId,
    };
  }


  CheckOutModel copyWith({
    String? id,
    String? user,
    String? service,
    String? serviceCustomer,
    String? provider,
    String? serviceMan,
    String? coupon,
    num? subtotal,
    num? serviceDiscount,
    num? couponDiscount,
    num? champaignDiscount,
    num? gst,
    num? platformFee,
    num? assurityfee,
    num? listingPrice,
    num? serviceDiscountPrice,
    num? priceAfterDiscount,
    num? couponDiscountPrice,
    num? serviceGSTPrice,
    num? platformFeePrice,
    num? assurityChargesPrice,
    num? extraServicePrice,
    String? commission,
    String? couponDiscountType,
    num? totalAmount,
    num? grandTotal,
    List<String>? paymentMethod,
    num? walletAmount,
    num? otherAmount,
    num? paidAmount,
    bool? isPartialPayment,
    num? remainingAmount,
    String? cashfreeMethod,
    String? paymentStatus,
    String? orderStatus,
    bool? cashInHand,
    num? cashInHandAmount,
    String? notes,
    bool? termsCondition,
    bool? isVerified,
    bool? isAccepted,
    String? acceptedDate,
    bool? isOtpVerified,
    bool? isCompleted,
    bool? commissionDistributed,
    bool? isCanceled,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    String? bookingId,
    String? otp,
  }) {
    return CheckOutModel(
      id: id ?? this.id,
      user: user ?? this.user,
      service: service ?? this.service,
      serviceCustomer: serviceCustomer ?? this.serviceCustomer,
      provider: provider ?? this.provider,
      serviceMan: serviceMan ?? this.serviceMan,
      coupon: coupon ?? this.coupon,
      subtotal: subtotal ?? this.subtotal,
      serviceDiscount: serviceDiscount ?? this.serviceDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      champaignDiscount: champaignDiscount ?? this.champaignDiscount,
      gst: gst ?? this.gst,
      platformFee: platformFee ?? this.platformFee,
      assurityfee: assurityfee ?? this.assurityfee,
      listingPrice: listingPrice ?? this.listingPrice,
      serviceDiscountPrice: serviceDiscountPrice ?? this.serviceDiscountPrice,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      couponDiscountPrice: couponDiscountPrice ?? this.couponDiscountPrice,
      serviceGSTPrice: serviceGSTPrice ?? this.serviceGSTPrice,
      platformFeePrice: platformFeePrice ?? this.platformFeePrice,
      assurityChargesPrice: assurityChargesPrice ?? this.assurityChargesPrice,
      extraServicePrice: extraServicePrice ?? this.extraServicePrice,
      commission: commission ?? this.commission,
      couponDiscountType: couponDiscountType ?? this.couponDiscountType,
      totalAmount: totalAmount ?? this.totalAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      walletAmount: walletAmount ?? this.walletAmount,
      otherAmount: otherAmount ?? this.otherAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      isPartialPayment: isPartialPayment ?? this.isPartialPayment,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      cashfreeMethod: cashfreeMethod ?? this.cashfreeMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      cashInHand: cashInHand ?? this.cashInHand,
      cashInHandAmount: cashInHandAmount ?? this.cashInHandAmount,
      notes: notes ?? this.notes,
      termsCondition: termsCondition ?? this.termsCondition,
      isVerified: isVerified ?? this.isVerified,
      isAccepted: isAccepted ?? this.isAccepted,
      acceptedDate: acceptedDate ?? this.acceptedDate,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      isCompleted: isCompleted ?? this.isCompleted,
      commissionDistributed: commissionDistributed ?? this.commissionDistributed,
      isCanceled: isCanceled ?? this.isCanceled,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      otp: otp ?? this.otp,
      bookingId: bookingId ?? this.bookingId,
    );
  }
}

