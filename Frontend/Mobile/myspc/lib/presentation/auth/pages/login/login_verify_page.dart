import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_event.dart';
import '../../bloc/login_state.dart';
import '../../widgets/auth_hero_widget.dart';
import '../../widgets/otp_field_widget.dart';
import '../../../common/widgets/primary_button.dart';

/// Second login screen, shown only after the server accepts an OTP request.
class LoginVerifyPage extends StatefulWidget {
  const LoginVerifyPage({required this.email, super.key});
  final String email;

  @override
  State<LoginVerifyPage> createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginOtpVerificationOpened(widget.email));
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) =>
            current.status == LoginStatus.success &&
            previous.status != LoginStatus.success,
        listener: (context, state) => context.go(AppConstants.homeRoute),
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final heroHeight =
                    (constraints.maxHeight * 0.40).clamp(220.0, 340.0);
                return Column(children: [
                  SizedBox(
                    height: heroHeight,
                    child: AuthHeroWidget(
                      variant: AuthHeroVariant.login,
                      availableHeight: heroHeight,
                    ),
                  ),
                  Expanded(child: _LoginOtpForm(otpController: _otpController, otpFocus: _otpFocus)),
                ]);
              },
            ),
          ),
        ),
      );
}

class _LoginOtpForm extends StatelessWidget {
  const _LoginOtpForm({required this.otpController, required this.otpFocus});
  final TextEditingController otpController;
  final FocusNode otpFocus;

  @override
  Widget build(BuildContext context) => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) => Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            26,
            28,
            26,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Verify your email', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('Enter the 6-digit code sent to ${state.email}.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),
              OtpFieldWidget(
                controller: otpController,
                focusNode: otpFocus,
                enabled: !state.isLoading,
                hint: 'Enter your 6-digit code.',
                onChanged: (value) => context.read<LoginBloc>().add(LoginFieldChanged(field: LoginField.otp, value: value)),
              ),
              if (state.status == LoginStatus.failure) ...[
                const SizedBox(height: 16),
                Text(state.errorMessage ?? 'Unable to verify the OTP.', style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 28),
              PrimaryButton(
                label: state.isLoading ? 'Verifying OTP...' : 'Verify & Login',
                isLoading: state.isLoading,
                enabled: state.otp.trim().length == 6 && !state.isLoading,
                onPressed: state.otp.trim().length == 6 && !state.isLoading
                    ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                    : null,
              ),
            ]),
          ),
        ),
      );
}
