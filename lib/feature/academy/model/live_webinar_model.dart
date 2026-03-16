class LiveWebinarModel {
  final bool success;
  final List<LiveWebinar> data;

  LiveWebinarModel({
    required this.success,
    required this.data,
  });

  factory LiveWebinarModel.fromJson(Map<String, dynamic> json) {
    return LiveWebinarModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LiveWebinar.fromJson(e))
          .toList(),
    );
  }
}

class LiveWebinar {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<String> displayVideoUrls;
  final String date;
  final String startTime;
  final String endTime;
  final bool closeStatus;
  final List<UserStatus> user; // 👈 exact matched
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  LiveWebinar({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.displayVideoUrls,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.closeStatus,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory LiveWebinar.fromJson(Map<String, dynamic> json) {
    return LiveWebinar(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      displayVideoUrls:
      (json['displayVideoUrls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      closeStatus: json['closeStatus'] ?? false,

      /// user array (list of objects)
      user: (json['user'] as List<dynamic>? ?? [])
          .map((e) => UserStatus.fromJson(e))
          .toList(),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,

      version: json['__v'] ?? 0,
    );
  }
}

class UserStatus {
  final String user;
  final bool status;
  final String id;

  UserStatus({
    required this.user,
    required this.status,
    required this.id,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      user: json['user'] ?? '',
      status: json['status'] ?? false,
      id: json['_id'] ?? '',
    );
  }
}
