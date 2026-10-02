import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({required this.scale, super.key});
  final double scale;
  @override
  Widget build(BuildContext context) => Container(height: 82 * scale, padding: EdgeInsets.symmetric(horizontal: 22 * scale, vertical: 10 * scale), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30 * scale))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_Nav(icon: Icons.forum_rounded, label: 'Chats', selected: true, scale: scale), _Nav(icon: Icons.groups_outlined, label: 'Spc', scale: scale), _Nav(icon: Icons.phone_outlined, label: 'Calls', scale: scale)]));
}
class _Nav extends StatelessWidget { const _Nav({required this.icon, required this.label, required this.scale, this.selected = false}); final IconData icon; final String label; final double scale; final bool selected;
  @override Widget build(BuildContext context) { final color = selected ? AppColors.orange : const Color(0xFF778393); return Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 25 * scale), SizedBox(height: 2 * scale), Text(label, style: TextStyle(color: color, fontSize: 12 * scale, fontWeight: selected ? FontWeight.w700 : FontWeight.w500))]); }
}
