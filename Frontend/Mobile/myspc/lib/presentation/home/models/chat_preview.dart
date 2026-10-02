import 'package:flutter/material.dart';

/// Static presentation data used until [HomeModel] is connected to the UI.
class ChatPreview {
  const ChatPreview({required this.name, required this.message, required this.time, required this.initials, required this.avatarColor, this.online = false, this.unread, this.image = false, this.group = false});
  final String name, message, time, initials;
  final Color avatarColor;
  final bool online, image, group;
  final int? unread;
}
