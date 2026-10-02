import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.scale, super.key});
  final double scale;
  @override
  Widget build(BuildContext context) => Row(children: [
    Text('MySpc', style: TextStyle(color: AppColors.orange, fontSize: 27 * scale, fontWeight: FontWeight.w800, letterSpacing: -1)), const Spacer(),
    Stack(clipBehavior: Clip.none, children: [Icon(Icons.groups_outlined, size: 28 * scale, color: const Color(0xFF132238)), Positioned(right: -1, top: -3, child: Container(width: 12 * scale, height: 12 * scale, decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle)))]),
    SizedBox(width: 17 * scale), Icon(Icons.more_vert, size: 27 * scale, color: const Color(0xFF132238)),
  ]);
}
