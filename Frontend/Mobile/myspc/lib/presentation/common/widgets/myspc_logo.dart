import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// MySpc logo — orange chat-bubble icon + "MySpc" wordmark.
/// Used in AuthHero and any other branded surface.
class MyspcLogo extends StatelessWidget {
  const MyspcLogo({super.key, this.size = LogoSize.medium});

  final LogoSize size;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (size) {
      LogoSize.small => 24.0,
      LogoSize.medium => 32.0,
      LogoSize.large => 40.0,
    };
    final fontSize = switch (size) {
      LogoSize.small => 16.0,
      LogoSize.medium => 22.0,
      LogoSize.large => 28.0,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Chat bubble icon (matches the web SVG logo)
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: CustomPaint(
            painter: _ChatBubblePainter(),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'MySpc',
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.orange,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

enum LogoSize { small, medium, large }

/// Draws the MySpc chat-bubble icon in orange
class _ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer rounded rectangle (chat bubble body)
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h * 0.78),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(bubbleRect, paint);

    // Tail (bottom-left triangle)
    final tailPath = Path()
      ..moveTo(w * 0.1, h * 0.75)
      ..lineTo(0, h)
      ..lineTo(w * 0.28, h * 0.75)
      ..close();
    canvas.drawPath(tailPath, paint);

    // Dots inside the bubble
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotY = h * 0.36;
    final dotR = w * 0.07;
    canvas.drawCircle(Offset(w * 0.3, dotY), dotR, dotPaint);
    canvas.drawCircle(Offset(w * 0.5, dotY), dotR, dotPaint);
    canvas.drawCircle(Offset(w * 0.7, dotY), dotR, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
