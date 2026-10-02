/// Mirrors the home API payload.
class HomeModel {
  const HomeModel({required this.pendingFriendRequests, required this.spaces});
  final bool pendingFriendRequests;
  final List<SpaceModel> spaces;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    pendingFriendRequests: json['pending_friend_requests'] as bool? ?? false,
    spaces: (json['spaces'] as List<dynamic>? ?? []).map((item) => SpaceModel.fromJson(item as Map<String, dynamic>)).toList(),
  );
}

class SpaceModel {
  const SpaceModel({required this.spaceId, required this.profile, required this.newestMessage, required this.isOnline, required this.unreadMessageCount});
  final String spaceId;
  final SpaceProfile profile;
  final NewestMessage newestMessage;
  final bool isOnline;
  final int unreadMessageCount;

  factory SpaceModel.fromJson(Map<String, dynamic> json) => SpaceModel(
    spaceId: json['space_id'] as String? ?? '',
    profile: SpaceProfile.fromJson(json['profile'] as Map<String, dynamic>? ?? const {}),
    newestMessage: NewestMessage.fromJson(json['newest_msg'] as Map<String, dynamic>? ?? const {}),
    isOnline: json['is_online'] as bool? ?? false,
    unreadMessageCount: json['num_unread_msg'] as int? ?? 0,
  );
}

class SpaceProfile {
  const SpaceProfile({required this.realName, this.avatarUrl});
  final String realName;
  final String? avatarUrl;
  factory SpaceProfile.fromJson(Map<String, dynamic> json) => SpaceProfile(realName: json['real_name'] as String? ?? '', avatarUrl: json['avatar_url'] as String?);
}

class NewestMessage {
  const NewestMessage({required this.message, required this.messageType, required this.messageTime, required this.isRead});
  final String message;
  final String messageType;
  final String messageTime;
  final bool isRead;
  factory NewestMessage.fromJson(Map<String, dynamic> json) => NewestMessage(
    message: json['msg'] as String? ?? '', messageType: json['msg_type'] as String? ?? '',
    messageTime: json['msg_time'] as String? ?? '', isRead: json['read_status'] as bool? ?? false,
  );
}
