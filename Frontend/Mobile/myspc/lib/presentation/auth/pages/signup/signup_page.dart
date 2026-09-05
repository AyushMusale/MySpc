import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/signup_bloc.dart';
import '../../bloc/signup_state.dart';
import 'widgets/auth_hero_widget.dart';
import 'widgets/signup_form_widget.dart';

/// Full signup screen — hero section (top) + scrollable form card (bottom).
///
/// Responsiveness strategy:
/// • [LayoutBuilder] gives the exact available height after SafeArea.
/// • The hero occupies 38–44 % of that height (clamped to 220–340 px).
/// • The form card occupies the rest via [Expanded].
/// • On very short screens (< 560 px, e.g. landscape) the hero collapses
///   to its minimum so the form always has enough room.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) =>
          current.status == SignupStatus.success &&
          previous.status != SignupStatus.success,
      listener: (context, state) {
        context.go(AppConstants.homeRoute);
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // ── Proportional hero height ──────────────────────────────────
              // 40 % of available height, clamped between 220 and 340 logical px.
              final heroHeight = (constraints.maxHeight * 0.40).clamp(220.0, 340.0);

              return Column(
                children: [
                  // ── Hero section — fixed proportional height ───────────────
                  SizedBox(
                    height: heroHeight,
                    child: AuthHeroWidget(
                      variant: AuthHeroVariant.signup,
                      availableHeight: heroHeight,
                    ),
                  ),

                  // ── Form card — fills the rest ─────────────────────────────
                  Expanded(
                    child: SignupFormWidget(
                      onLoginTap: () => context.go(AppConstants.loginRoute),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
