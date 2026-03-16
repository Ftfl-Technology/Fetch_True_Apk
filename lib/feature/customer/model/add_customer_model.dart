import 'package:dio/dio.dart';

class Otp {
  final bool verified;

  Otp({required this.verified});

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
    };
  }

  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(verified: json['verified'] ?? false);
  }
}

class AddCustomerModel {
  final Otp? otp;
  final String? id;
  final String fullName;
  final String phone;
  final String email;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String country;
  final String user;

  AddCustomerModel({
    this.otp,
    this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.user,
  });

  factory AddCustomerModel.fromJson(Map<String, dynamic> json) {
    return AddCustomerModel(
      otp: json['otp'] != null ? Otp.fromJson(json['otp']) : null,
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      user: json['user'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'user': user,
    };
  }

  /// ✅ Convert to FormData for API
  FormData toFormData() {
    return FormData.fromMap({
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'description': description ?? '',
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'user': user,
    });
  }
}
