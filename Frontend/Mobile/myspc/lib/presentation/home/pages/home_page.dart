import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../models/chat_preview.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_search_field.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';

/// Static screen only. BlocConsumer is the future integration boundary.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const _chats = [
    ChatPreview(name: 'Arjun Verma', message: 'Hey! How are you?', time: '10:28 AM', initials: 'AV', avatarColor: Color(0xFF614B3B), online: true, unread: 2),
    ChatPreview(name: 'Priya Sharma', message: 'Let’s catch up later.', time: '9:45 AM', initials: 'PS', avatarColor: Color(0xFF6F927D), online: true, unread: 1),
    ChatPreview(name: 'Rohan Mehta', message: 'Shared an image', time: 'Yesterday', initials: 'RM', avatarColor: Color(0xFF426D81), online: true, image: true),
    ChatPreview(name: 'Ananya Iyer', message: 'Thank you!', time: 'Yesterday', initials: 'AI', avatarColor: Color(0xFF9B7A72)),
    ChatPreview(name: 'Kabir Singh', message: 'See you there!', time: 'Mon', initials: 'KS', avatarColor: Color(0xFF827364)),
    ChatPreview(name: 'MySpc Team', message: 'Announcement: Updates...', time: 'Mon', initials: '', avatarColor: Color(0xFFFFE4D0), group: true),
    ChatPreview(name: 'Vedant', message: 'Sounds good!', time: '', initials: 'V', avatarColor: Color(0xFF7A8B66), online: true),
  ];

  @override
  Widget build(BuildContext context) => BlocConsumer<HomeBloc, HomeState>(
    listener: (context, state) {
      // Reserved for one-time effects; no business logic is implemented here.
    },
    builder: (context, state) => LayoutBuilder(
      builder: (context, constraints) {
        final scale =
            (constraints.maxWidth / 390).clamp(0.82, 1.12).toDouble();
        final compact = constraints.maxHeight < 700;
        return Scaffold(
          backgroundColor: AppColors.cream,
          floatingActionButton: SizedBox(
            width: 52 * scale,
            height: 52 * scale,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.orange,
              shape: const CircleBorder(),
              child: Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 24 * scale),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: SafeArea(top: false, child: HomeBottomNavigation(scale: scale)),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20 * scale, compact ? 18 * scale : 24 * scale, 20 * scale, 0),
              child: Column(children: [
                HomeHeader(scale: scale),
                SizedBox(height: compact ? 24 * scale : 32 * scale),
                ChatSearchField(scale: scale),
                SizedBox(height: 18 * scale),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 12 * scale),
                    itemCount: _chats.length,
                    separatorBuilder: (_, __) => SizedBox(height: 2 * scale),
                    itemBuilder: (_, index) => ChatListItem(chat: _chats[index], scale: scale),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    ),
  );
}
