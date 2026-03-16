class PackageBuyPaymentModel {
  final int subAmount;
  final bool isPartialPaymentAllowed;
  final String description;
  final String orderId;
  final Customer customer;
  final Udf udf;

  PackageBuyPaymentModel({
    required this.subAmount,
    required this.isPartialPaymentAllowed,
    required this.description,
    required this.orderId,
    required this.customer,
    required this.udf,
  });

  Map<String, dynamic> toJson() {
    return {
      "subAmount": subAmount,
      "isPartialPaymentAllowed": isPartialPaymentAllowed,
      "description": description,
      "orderId": orderId,
      "customer": customer.toJson(),
      "udf": udf.toJson(),
    };
  }
}

class Customer {
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  Customer({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "customer_name": customerName,
      "customer_email": customerEmail,
      "customer_phone": customerPhone,
    };
  }
}

class Udf {
  final String udf1;
  final String udf2;
  final String udf3;

  Udf({
    required this.udf1,
    required this.udf2,
    required this.udf3,
  });

  Map<String, dynamic> toJson() {
    return {
      "udf1": udf1,
      "udf2": udf2,
      "udf3": udf3,
    };
  }
}
