class ProfileModel {
  const ProfileModel({
    required this.userId,
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String username;
  final String displayName;
  final String? avatarUrl;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userId: json['userId'] as String,
        username: json['username'] as String,
        displayName: json['displayName'] as String,
        avatarUrl: json['avatarUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'displayName': displayName,
        'avatarUrl': avatarUrl,
      };
}
