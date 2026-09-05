/// Pure domain entity — no JSON, no framework dependencies
class ProfileEntity {
  const ProfileEntity({
    required this.userId,
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String username;
  final String displayName;
  final String? avatarUrl;
}
