class FavoriteProviderModel {
  final List<String> favoriteProvider;

  FavoriteProviderModel({required this.favoriteProvider});

  factory FavoriteProviderModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProviderModel(
      favoriteProvider: List<String>.from(json['data']['favoriteProviders']),
    );
  }
}


class FavoriteResponse {
  final bool success;
  final String message;

  FavoriteResponse({required this.success, required this.message});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
