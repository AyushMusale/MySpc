import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_state.dart';
import '../../widgets/auth_hero_widget.dart';
import 'widgets/login_form_widget.dart';

/// Full login screen — hero section (top) + scrollable form card (bottom).
/// Mirrors SignupPage layout and responsiveness.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          current.status == LoginStatus.success &&
          previous.status != LoginStatus.success,
      listener: (context, state) {
        context.go(AppConstants.homeRoute);
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Proportional hero height: 40% of available height clamped 220-340
              final heroHeight =
                  (constraints.maxHeight * 0.40).clamp(220.0, 340.0);

              return Column(
                children: [
                  SizedBox(
                    height: heroHeight,
                    child: AuthHeroWidget(
                      variant: AuthHeroVariant.login,
                      availableHeight: heroHeight,
                    ),
                  ),
                  Expanded(
                    child: LoginFormWidget(
                      onSignupTap: () => context.go(AppConstants.signupRoute),
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
