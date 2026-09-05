import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Reusable labelled text field — mirrors the web Input component.
/// Used by signup, login, and any future auth forms.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.prefixIcon,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefixIcon;
  final String? hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
        ),
        const SizedBox(height: 6),

        // Input
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          maxLength: maxLength,
          onChanged: onChanged,
          autofillHints: autofillHints,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.text,
                fontSize: 14,
              ),
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IconTheme(
                      data: const IconThemeData(
                        color: AppColors.muted,
                        size: 18,
                      ),
                      child: prefixIcon!,
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            counterText: '', // hide the maxLength counter
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        // Hint text below field
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
          ),
        ],
      ],
    );
  }
}
