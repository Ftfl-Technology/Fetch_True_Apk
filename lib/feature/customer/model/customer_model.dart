class CustomerModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String description;
  final String address;
  final String city;
  final String state;
  final String country;
  final String user;
  final bool isDeleted;
  final String customerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool otpVerified;

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.user,
    required this.isDeleted,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
    required this.otpVerified,
  });


  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["_id"] ?? "",
      fullName: json["fullName"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      description: json["description"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
      user: json["user"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
      customerId: json["customerId"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      otpVerified: json["otp"]?["verified"] ?? false,
    );
  }
}
