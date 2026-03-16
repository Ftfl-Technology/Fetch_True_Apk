import 'dart:convert';

class TeamResponse {
  final bool success;
  final List<MyTeamModel> team;

  TeamResponse({
    required this.success,
    required this.team,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      success: json['success'] ?? false,
      team: (json['team'] as List<dynamic>? ?? [])
          .map((e) => MyTeamModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "team": team.map((e) => e.toJson()).toList(),
    };
  }
}

class MyTeamModel {
  final User? user;
  final double totalEarningsFromShare2;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;
  final int activeTeamCount;
  final int inactiveTeamCount;
  final List<SubTeam> team;

  MyTeamModel({
    this.user,
    required this.totalEarningsFromShare2,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
    required this.activeTeamCount,
    required this.inactiveTeamCount,
    required this.team,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) {
    return MyTeamModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalEarningsFromShare2:
      (json['totalEarningsFromShare_2'] ?? 0).toDouble(),
      leads: (json['leads'] as List<dynamic>? ?? [])
          .map((e) => Lead.fromJson(e))
          .toList(),
      activeLeadCount: json['activeLeadCount'] ?? 0,
      completeLeadCount: json['completeLeadCount'] ?? 0,
      activeTeamCount: json['activeTeamCount'] ?? 0,
      inactiveTeamCount: json['inactiveTeamCount'] ?? 0,
      team: (json['team'] as List<dynamic>? ?? [])
          .map((e) => SubTeam.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user?.toJson(),
      "totalEarningsFromShare_2": totalEarningsFromShare2,
      "leads": leads.map((e) => e.toJson()).toList(),
      "activeLeadCount": activeLeadCount,
      "completeLeadCount": completeLeadCount,
      "activeTeamCount": activeTeamCount,
      "inactiveTeamCount": inactiveTeamCount,
      "team": team.map((e) => e.toJson()).toList(),
    };
  }
}

class SubTeam {
  final User? user;
  final double totalEarningsFromShare3;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;

  SubTeam({
    this.user,
    required this.totalEarningsFromShare3,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
  });

  factory SubTeam.fromJson(Map<String, dynamic> json) {
    return SubTeam(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalEarningsFromShare3:
      (json['totalEarningsFromShare_3'] ?? 0).toDouble(),
      leads: (json['leads'] as List<dynamic>? ?? [])
          .map((e) => Lead.fromJson(e))
          .toList(),
      activeLeadCount: json['activeLeadCount'] ?? 0,
      completeLeadCount: json['completeLeadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user?.toJson(),
      "totalEarningsFromShare_3": totalEarningsFromShare3,
      "leads": leads.map((e) => e.toJson()).toList(),
      "activeLeadCount": activeLeadCount,
      "completeLeadCount": completeLeadCount,
    };
  }
}

class Address {
  final String houseNumber;
  final String landmark;
  final String state;
  final String city;
  final String pinCode;
  final String country;
  final String fullAddress;

  Address({
    required this.houseNumber,
    required this.landmark,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.country,
    required this.fullAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      houseNumber: json['houseNumber'] ?? '',
      landmark: json['landmark'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      country: json['country'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "houseNumber": houseNumber,
      "landmark": landmark,
      "state": state,
      "city": city,
      "pinCode": pinCode,
      "country": country,
      "fullAddress": fullAddress,
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? userId;
  final String? referralCode;
  final String? profilePhoto;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final bool packageActive;
  final String? packageStatus;
  final int packagePrice;
  final int packageAmountPaid;
  final bool? isDeleted;
  final bool? personalDetailsCompleted;
  final bool? additionalDetailsCompleted;
  final bool? addressCompleted;
  final String? password;
  final String? referredBy;
  final List<String>? myTeams;
  final bool? isAgree;
  final List<String>? serviceCustomers;
  final List<String>? favoriteServices;
  final List<String>? favoriteProviders;
  final List<String>? fcmTokens;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Address? homeAddress;
  final Address? workAddress;
  final Address? otherAddress;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    this.userId,
    this.referralCode,
    this.profilePhoto,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.packageActive,
    this.packageStatus,
    required this.packagePrice,
    required this.packageAmountPaid,
    this.isDeleted,
    this.personalDetailsCompleted,
    this.additionalDetailsCompleted,
    this.addressCompleted,
    this.password,
    this.referredBy,
    this.myTeams,
    this.isAgree,
    this.serviceCustomers,
    this.favoriteServices,
    this.favoriteProviders,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
    this.homeAddress,
    this.workAddress,
    this.otherAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      userId: json['userId'],
      referralCode: json['referralCode'],
      profilePhoto: json['profilePhoto'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      packageActive: json['packageActive'] ?? false,
      packageStatus: json['packageStatus'],
      packagePrice: json['packagePrice'] ?? 0,
      packageAmountPaid: json['packageAmountPaid'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      personalDetailsCompleted: json['personalDetailsCompleted'],
      additionalDetailsCompleted: json['additionalDetailsCompleted'],
      addressCompleted: json['addressCompleted'],
      password: json['password'],
      referredBy: json['referredBy'],
      myTeams: (json['myTeams'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      isAgree: json['isAgree'],
      serviceCustomers: (json['serviceCustomers'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      favoriteServices: (json['favoriteServices'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      favoriteProviders: (json['favoriteProviders'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      homeAddress: json['homeAddress'] != null ? Address.fromJson(json['homeAddress']) : null,
      workAddress: json['workAddress'] != null ? Address.fromJson(json['workAddress']) : null,
      otherAddress: json['otherAddress'] != null ? Address.fromJson(json['otherAddress']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "email": email,
      "mobileNumber": mobileNumber,
      "userId": userId,
      "referralCode": referralCode,
      "profilePhoto": profilePhoto,
      "isEmailVerified": isEmailVerified,
      "isMobileVerified": isMobileVerified,
      "packageActive": packageActive,
      "packageStatus": packageStatus,
      "packagePrice": packagePrice,
      "packageAmountPaid": packageAmountPaid,
      "isDeleted": isDeleted,
      "personalDetailsCompleted": personalDetailsCompleted,
      "additionalDetailsCompleted": additionalDetailsCompleted,
      "addressCompleted": addressCompleted,
      "password": password,
      "referredBy": referredBy,
      "myTeams": myTeams,
      "isAgree": isAgree,
      "serviceCustomers": serviceCustomers,
      "favoriteServices": favoriteServices,
      "favoriteProviders": favoriteProviders,
      "fcmTokens": fcmTokens,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "homeAddress": homeAddress?.toJson(),
      "workAddress": workAddress?.toJson(),
      "otherAddress": otherAddress?.toJson(),
    };
  }
}

// class User {
//   final String id;
//   final String fullName;
//   final String email;
//   final String mobileNumber;
//   final String? userId;
//   final String? referralCode;
//   final String? profilePhoto;
//   final bool isEmailVerified;
//   final bool isMobileVerified;
//   final bool packageActive;
//   final String? packageStatus;
//   final int packagePrice;
//   final int packageAmountPaid;
//   final bool? isDeleted;
//
//   User({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.mobileNumber,
//     this.userId,
//     this.referralCode,
//     this.profilePhoto,
//     required this.isEmailVerified,
//     required this.isMobileVerified,
//     required this.packageActive,
//     this.packageStatus,
//     required this.packagePrice,
//     required this.packageAmountPaid,
//     this.isDeleted,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       userId: json['userId'],
//       referralCode: json['referralCode'],
//       profilePhoto: json['profilePhoto'],
//       isEmailVerified: json['isEmailVerified'] ?? false,
//       isMobileVerified: json['isMobileVerified'] ?? false,
//       packageActive: json['packageActive'] ?? false,
//       packageStatus: json['packageStatus'],
//       packagePrice: json['packagePrice'] ?? 0,
//       packageAmountPaid: json['packageAmountPaid'] ?? 0,
//       isDeleted: json['isDeleted'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "fullName": fullName,
//       "email": email,
//       "mobileNumber": mobileNumber,
//       "userId": userId,
//       "referralCode": referralCode,
//       "profilePhoto": profilePhoto,
//       "isEmailVerified": isEmailVerified,
//       "isMobileVerified": isMobileVerified,
//       "packageActive": packageActive,
//       "packageStatus": packageStatus,
//       "packagePrice": packagePrice,
//       "packageAmountPaid": packageAmountPaid,
//       "isDeleted": isDeleted,
//     };
//   }
// }

class Lead {
  final String checkoutId;
  final String leadId;
  final String status;
  final double amount;
  final double commissionEarned;

  Lead({
    required this.checkoutId,
    required this.leadId,
    required this.status,
    required this.amount,
    required this.commissionEarned,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      checkoutId: json['checkoutId'] ?? '',
      leadId: json['leadId'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      commissionEarned: (json['commissionEarned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "checkoutId": checkoutId,
      "leadId": leadId,
      "status": status,
      "amount": amount,
      "commissionEarned": commissionEarned,
    };
  }
}
