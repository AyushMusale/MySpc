import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../bloc/signup_bloc.dart';
import '../../../bloc/signup_event.dart';
import '../../../bloc/signup_state.dart';
import '../../../widgets/auth_text_field.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../widgets/email_field_row.dart';
import '../../../widgets/otp_field_widget.dart';

/// The white rounded-top card containing the full signup form.
/// Mirrors the Card + form structure from SignupForm.tsx.
class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key, this.onLoginTap});

  final VoidCallback? onLoginTap;

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _otpFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _handlePrimaryAction(BuildContext context, SignupState state) {
    if (!state.otpSent) return; // shouldn't reach but guard
    if (!state.otpVerified) {
      context.read<SignupBloc>().add(const SignupVerifyOtpRequested());
    } else {
      context.read<SignupBloc>().add(const SignupSubmitted());
    }
  }

  String _primaryLabel(SignupState state) {
    if (state.isLoading) {
      if (!state.otpSent) return 'Sending OTP…';
      if (!state.otpVerified) return 'Verifying OTP…';
      return 'Creating Account…';
    }
    if (!state.otpVerified) return 'Verify OTP';
    return 'Create Account';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        // Sync controllers from external state resets
        if (state.status == SignupStatus.initial) {
          _nameController.clear();
          _usernameController.clear();
          _emailController.clear();
          _otpController.clear();
        }
      },
      builder: (context, state) {
        final screenSize = MediaQuery.sizeOf(context);
        // Responsive horizontal padding — wider on tablets / large phones
        final hPad = (screenSize.width * 0.065).clamp(20.0, 40.0);
        // Vertical field spacing — breathes on tall screens, tighter on small
        final fieldSpacing = (screenSize.height * 0.025).clamp(14.0, 22.0);

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
                  'Create Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's get you all set up.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // ── Name field ────────────────────────────────────────────
                AuthTextField(
                  label: 'Name',
                  controller: _nameController,
                  focusNode: _nameFocus,
                  placeholder: 'Preferably real name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  onChanged: (v) => context
                      .read<SignupBloc>()
                      .add(SignupFieldChanged(
                        field: SignupField.displayName,
                        value: v,
                      )),
                ),
                SizedBox(height: fieldSpacing),

                // ── Username field ────────────────────────────────────────
                AuthTextField(
                  label: 'Username',
                  controller: _usernameController,
                  focusNode: _usernameFocus,
                  placeholder: 'Choose a username',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  onChanged: (v) => context
                      .read<SignupBloc>()
                      .add(SignupFieldChanged(
                        field: SignupField.username,
                        value: v,
                      )),
                ),
                SizedBox(height: fieldSpacing),

                // ── Email + Verify button ─────────────────────────────────
                EmailFieldRow(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  isLoading: state.isLoading && !state.otpSent,
                  isVerified: state.otpSent,
                  onChanged: (v) => context
                      .read<SignupBloc>()
                      .add(SignupFieldChanged(
                        field: SignupField.email,
                        value: v,
                      )),
                  onVerifyTap: state.email.trim().isNotEmpty &&
                          !state.isLoading
                      ? () => context
                          .read<SignupBloc>()
                          .add(const SignupSendOtpRequested())
                      : null,
                ),
                SizedBox(height: fieldSpacing),

                // ── OTP field ─────────────────────────────────────────────
                OtpFieldWidget(
                  controller: _otpController,
                  focusNode: _otpFocus,
                  enabled: state.otpSent,
                  hint: state.otpSent
                      ? "We've sent a 6-digit code to your email."
                      : 'Verify your email to receive an OTP.',
                  onChanged: (v) => context
                      .read<SignupBloc>()
                      .add(SignupFieldChanged(
                        field: SignupField.otp,
                        value: v,
                      )),
                ),
                SizedBox(height: fieldSpacing * 0.5),

                // ── Error message ─────────────────────────────────────────
                if (state.status == SignupStatus.failure &&
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

                // ── Primary CTA ───────────────────────────────────────────
                PrimaryButton(
                  label: _primaryLabel(state),
                  isLoading: state.isLoading,
                  enabled: state.otpSent,
                  onPressed: state.otpSent
                      ? () => _handlePrimaryAction(context, state)
                      : null,
                ),

                const SizedBox(height: 20),

                // ── Login link ────────────────────────────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.muted,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: widget.onLoginTap,
                            child: Text(
                              'Login',
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
