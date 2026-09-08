import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// Email input + "Verify Email" outline button row.
/// Mirrors the inline email row in SignupForm.tsx and LoginForm.tsx.
class EmailFieldRow extends StatelessWidget {
  const EmailFieldRow({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onVerifyTap,
    this.focusNode,
    this.isLoading = false,
    this.isVerified = false,
    this.buttonLabel = 'Verify Email',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Null disables the button
  final VoidCallback? onVerifyTap;

  final FocusNode? focusNode;
  final bool isLoading;
  final bool isVerified;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
        ),
        const SizedBox(height: 6),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email text field — takes all remaining space
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: onChanged,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      size: 18,
                      color: AppColors.muted,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Verify button
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: isVerified || isLoading ? null : onVerifyTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.orange,
                  side: BorderSide(
                    color: isVerified
                        ? AppColors.border
                        : AppColors.orange,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  disabledForegroundColor:
                      AppColors.muted.withValues(alpha: 0.6),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.orange),
                        ),
                      )
                    : Text(
                        isVerified ? 'Sent ✓' : buttonLabel,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isVerified
                              ? AppColors.muted
                              : AppColors.orange,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
