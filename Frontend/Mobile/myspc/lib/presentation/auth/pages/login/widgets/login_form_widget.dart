import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../bloc/login_bloc.dart';
import '../../../bloc/login_event.dart';
import '../../../bloc/login_state.dart';
import '../../../widgets/email_field_row.dart';
import '../../../widgets/otp_field_widget.dart';

/// The white rounded-top card containing the full login form.
/// Mirrors the Card + form structure from LoginForm.tsx.
class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key, this.onSignupTap});

  final VoidCallback? onSignupTap;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  final _emailFocus = FocusNode();
  final _otpFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _emailFocus.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _handlePrimaryAction(BuildContext context, LoginState state) {
    if (!state.otpSent) {
      if (state.email.trim().isNotEmpty) {
        context.read<LoginBloc>().add(const LoginSendOtpRequested());
      }
    } else {
      if (state.otp.trim().length == 6) {
        context.read<LoginBloc>().add(const LoginSubmitted());
      }
    }
  }

  String _primaryLabel(LoginState state) {
    if (state.isLoading) {
      return state.otpSent ? 'Logging in…' : 'Sending OTP…';
    }
    return state.otpSent ? 'Login' : 'Continue';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.initial) {
          _emailController.clear();
          _otpController.clear();
        }
      },
      builder: (context, state) {
        final screenSize = MediaQuery.sizeOf(context);
        final hPad = (screenSize.width * 0.065).clamp(20.0, 40.0);
        final fieldSpacing = (screenSize.height * 0.025).clamp(14.0, 22.0);

        final bool isPrimaryEnabled = state.isLoading
            ? false
            : state.otpSent
                ? state.otp.trim().length == 6
                : state.email.trim().isNotEmpty;

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: hPad,
              right: hPad,
              top: 28,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Heading
                Text(
                  'Login to MySpc',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's get you back in.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // ── Email field row ──────────────────────────────────────────
                EmailFieldRow(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  buttonLabel: 'Send OTP',
                  isLoading: state.isLoading && !state.otpSent,
                  isVerified: state.otpSent,
                  onChanged: (v) => context.read<LoginBloc>().add(
                        LoginFieldChanged(field: LoginField.email, value: v),
                      ),
                  onVerifyTap: state.email.trim().isNotEmpty && !state.isLoading
                      ? () => context
                          .read<LoginBloc>()
                          .add(const LoginSendOtpRequested())
                      : null,
                ),
                SizedBox(height: fieldSpacing),

                // ── OTP field ────────────────────────────────────────────────
                if (state.otpSent) ...[
                  OtpFieldWidget(
                    controller: _otpController,
                    focusNode: _otpFocus,
                    enabled: true,
                    hint: "We've sent a 6-digit code to your email.",
                    onChanged: (v) => context.read<LoginBloc>().add(
                          LoginFieldChanged(field: LoginField.otp, value: v),
                        ),
                  ),
                  SizedBox(height: fieldSpacing * 0.5),
                ],

                // ── Error message ────────────────────────────────────────────
                if (state.status == LoginStatus.failure &&
                    state.errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // ── Primary CTA (Continue / Login) ───────────────────────────
                PrimaryButton(
                  label: _primaryLabel(state),
                  isLoading: state.isLoading,
                  enabled: isPrimaryEnabled,
                  onPressed: isPrimaryEnabled
                      ? () => _handlePrimaryAction(context, state)
                      : null,
                ),

                // ── Social login divider & button (mirrors Web LoginForm) ───
                if (!state.otpSent) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: null, // Disabled matching Web implementation
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        disabledForegroundColor:
                            AppColors.muted.withValues(alpha: 0.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _GoogleGLogo(size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Sign up link ─────────────────────────────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.muted,
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: widget.onSignupTap,
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Lightweight Google "G" icon painter
class _GoogleGLogo extends StatelessWidget {
  const _GoogleGLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          'G',
          style: GoogleFonts.inter(
            fontSize: size * 0.9,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}
