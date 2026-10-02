import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/chat_preview.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({required this.chat, required this.scale, super.key});
  final ChatPreview chat;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final radius = 27.0 * scale;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * scale),
      child: Row(children: [
        _Avatar(chat: chat, radius: radius),
        SizedBox(width: 12 * scale),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(chat.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color(0xFF132238), fontSize: 17 * scale, fontWeight: FontWeight.w700)),
          SizedBox(height: 3 * scale),
          Row(children: [
            if (chat.image) ...[Icon(Icons.image_outlined, color: AppColors.muted, size: 18 * scale), SizedBox(width: 4 * scale)],
            Expanded(child: Text(chat.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color(0xFF778393), fontSize: 14 * scale))),
          ]),
        ])),
        SizedBox(width: 8 * scale),
        SizedBox(width: 57 * scale, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(chat.time, style: TextStyle(color: AppColors.muted, fontSize: 12 * scale)),
          if (chat.unread != null) ...[SizedBox(height: 5 * scale), Container(width: 25 * scale, height: 25 * scale, alignment: Alignment.center, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle), child: Text('${chat.unread}', style: TextStyle(color: Colors.white, fontSize: 13 * scale)))],
        ])),
      ]),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.chat, required this.radius});
  final ChatPreview chat;
  final double radius;

  @override
  Widget build(BuildContext context) => Stack(clipBehavior: Clip.none, children: [
    CircleAvatar(radius: radius, backgroundColor: chat.avatarColor, child: chat.group ? Icon(Icons.groups_rounded, color: AppColors.orange, size: radius) : Text(chat.initials, style: TextStyle(color: Colors.white, fontSize: radius * .55, fontWeight: FontWeight.w700))),
    Positioned(right: -1, bottom: -1, child: Container(width: radius * .52, height: radius * .52, decoration: BoxDecoration(color: chat.online ? const Color(0xFF00C853) : const Color(0xFFB8BEC5), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
  ]);
}
