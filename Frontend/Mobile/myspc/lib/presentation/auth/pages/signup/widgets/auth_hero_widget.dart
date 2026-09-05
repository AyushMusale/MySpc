import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/myspc_logo.dart';

/// The hero section at the top of the signup/login screens.
///
/// Responsiveness strategy:
/// • All sizes (fonts, illustration, spacing) are derived from [availableHeight].
/// • Uses [_HeroSizes] to compute every dimension in one place.
/// • The illustration hides on very short screens (< 260 px) to avoid crowding.
class AuthHeroWidget extends StatelessWidget {
  const AuthHeroWidget({
    super.key,
    this.variant = AuthHeroVariant.signup,
    required this.availableHeight,
  });

  final AuthHeroVariant variant;

  /// The vertical space allocated by the parent (from LayoutBuilder).
  final double availableHeight;

  @override
  Widget build(BuildContext context) {
    final content = _heroContent[variant]!;
    final s = _HeroSizes.from(availableHeight);

    return Stack(
      children: [
        // Paper-plane icon (top-right)
        Positioned(
          right: s.hPad,
          top: s.vPadTop * 0.5,
          child: _PaperPlaneIcon(size: s.planeSize),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(s.hPad, s.vPadTop, s.hPad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo — scales with screen
              MyspcLogo(
                size: s.isCompact ? LogoSize.small : LogoSize.medium,
              ),
              SizedBox(height: s.logoToHeadline),

              // Headline + illustration row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: s.headlineFontSize,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                              height: 1.15,
                            ),
                            children: content.title,
                          ),
                        ),
                        SizedBox(height: s.headlineToSubtitle),
                        if (!s.isCompact)
                          Text(
                            content.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: s.subtitleFontSize,
                              color: AppColors.muted,
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(width: s.isCompact ? 8 : 12),

                  // Illustration — hidden on very short screens
                  if (!s.hideIllustration)
                    _ChatIllustration(size: s.illustrationSize),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Computes all responsive dimensions from the available hero height.
/// Single source of truth — change the ratios here, everything follows.
class _HeroSizes {
  const _HeroSizes._({
    required this.availableHeight,
    required this.hPad,
    required this.vPadTop,
    required this.logoToHeadline,
    required this.headlineToSubtitle,
    required this.headlineFontSize,
    required this.subtitleFontSize,
    required this.illustrationSize,
    required this.planeSize,
    required this.isCompact,
    required this.hideIllustration,
  });

  factory _HeroSizes.from(double h) {
    // Breakpoints
    final isCompact = h < 260; // very short (landscape / small phone)
    final isMedium = h < 300;  // medium (SE-size)
    final hideIllustration = h < 230;

    return _HeroSizes._(
      availableHeight: h,
      hPad: 24,
      vPadTop: isCompact ? 8 : 12,
      logoToHeadline: isCompact ? 10 : (isMedium ? 14 : 20),
      headlineToSubtitle: isCompact ? 6 : 10,
      headlineFontSize: isCompact ? 22 : (isMedium ? 25 : 30),
      subtitleFontSize: isMedium ? 12 : 13,
      illustrationSize: isCompact ? 80 : (isMedium ? 100 : 120),
      planeSize: isCompact ? 26 : (isMedium ? 30 : 36),
      isCompact: isCompact,
      hideIllustration: hideIllustration,
    );
  }

  final double availableHeight;
  final double hPad;
  final double vPadTop;
  final double logoToHeadline;
  final double headlineToSubtitle;
  final double headlineFontSize;
  final double subtitleFontSize;
  final double illustrationSize;
  final double planeSize;
  final bool isCompact;
  final bool hideIllustration;
}

// ── Enums / content ──────────────────────────────────────────────────────────

enum AuthHeroVariant { signup, login }

class _HeroContent {
  const _HeroContent({required this.title, required this.subtitle});
  final List<TextSpan> title;
  final String subtitle;
}

const _heroContent = {
  AuthHeroVariant.signup: _HeroContent(
    title: [
      TextSpan(text: 'Connect.\nChat.\n'),
      TextSpan(
        text: 'Belong.',
        style: TextStyle(color: AppColors.orange),
      ),
    ],
    subtitle:
        'MySpc helps you connect with people who matter and build real relationships.',
  ),
  AuthHeroVariant.login: _HeroContent(
    title: [
      TextSpan(text: 'Welcome '),
      TextSpan(
        text: 'Back!',
        style: TextStyle(color: AppColors.orange),
      ),
    ],
    subtitle:
        "Glad to see you again. Let's continue your journey and stay connected.",
  ),
};

// ── Decorative widgets ───────────────────────────────────────────────────────

/// Chat-bubble illustration. [size] is the bounding box dimension.
/// All internal proportions are percentage-based so it scales perfectly.
class _ChatIllustration extends StatelessWidget {
  const _ChatIllustration({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    // All sub-dimensions as fractions of [size]
    final bigW = size * 0.75;
    final bigH = size * 0.60;
    final smallW = size * 0.60;
    final smallH = size * 0.50;
    final heartD = size * 0.25;
    final dotD = size * 0.05;
    final smDotD = size * 0.042;
    final iconSize = size * 0.117;
    final bubbleR = size * 0.15;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Large orange speech bubble
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: bigW,
              height: bigH,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleR),
                  topRight: Radius.circular(bubbleR),
                  bottomRight: Radius.circular(bubbleR),
                  bottomLeft: Radius.circular(size * 0.033),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Dot(color: Colors.white, size: dotD),
                    SizedBox(width: size * 0.042),
                    _Dot(color: Colors.white, size: dotD),
                    SizedBox(width: size * 0.042),
                    _Dot(color: Colors.white, size: dotD),
                  ],
                ),
              ),
            ),
          ),

          // Smaller cream speech bubble with smiley
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: smallW,
              height: smallH,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.117),
                  topRight: Radius.circular(size * 0.117),
                  bottomLeft: Radius.circular(size * 0.117),
                  bottomRight: Radius.circular(size * 0.033),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomPaint(
                  size: Size(size * 0.233, size * 0.233),
                  painter: _SmileyPainter(),
                ),
              ),
            ),
          ),

          // Heart circle (bottom-left)
          Positioned(
            bottom: size * 0.067,
            left: 0,
            child: Container(
              width: heartD,
              height: heartD,
              decoration: BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                color: AppColors.orange,
                size: iconSize,
              ),
            ),
          ),

          // Decorative dot — top right
          Positioned(
            top: size * 0.083,
            right: size * 0.033,
            child: Container(
              width: smDotD,
              height: smDotD,
              decoration: const BoxDecoration(
                color: AppColors.orange30,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative dot — middle
          Positioned(
            bottom: size * 0.25,
            left: size * 0.33,
            child: Container(
              width: smDotD * 0.85,
              height: smDotD * 0.85,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared primitives ────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final u = size.width / 28; // 1 "unit" — scales with painter size

    canvas.drawCircle(Offset(cx - 6 * u, cy - 4 * u), 2.2 * u, paint);
    canvas.drawCircle(Offset(cx + 6 * u, cy - 4 * u), 2.2 * u, paint);

    final smilePaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * u
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(cx - 7 * u, cy + 3 * u)
      ..quadraticBezierTo(cx, cy + 10 * u, cx + 7 * u, cy + 3 * u);
    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaperPlaneIcon extends StatelessWidget {
  const _PaperPlaneIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PaperPlanePainter(),
    );
  }
}

class _PaperPlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.5)
        ..lineTo(w, 0)
        ..lineTo(w * 0.6, h)
        ..close(),
      Paint()
        ..color = AppColors.orange
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.5)
        ..lineTo(w * 0.6, h)
        ..lineTo(w * 0.35, h * 0.55)
        ..close(),
      Paint()
        ..color = AppColors.orangeDark
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
