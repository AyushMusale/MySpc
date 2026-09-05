import 'package:flutter/material.dart';
import '../../../widgets/auth_text_field.dart';

/// OTP input field with a hint message below.
/// Mirrors the OTP Input in SignupForm.tsx.
class OtpFieldWidget extends StatelessWidget {
  const OtpFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.hint,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      label: 'Enter OTP',
      controller: controller,
      focusNode: focusNode,
      placeholder: 'Enter 6-digit OTP',
      prefixIcon: const Icon(Icons.shield_outlined),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      enabled: enabled,
      hint: hint,
      autofillHints: const [AutofillHints.oneTimeCode],
      onChanged: (v) {
        // Allow only digits
        final digitsOnly = v.replaceAll(RegExp(r'[^0-9]'), '');
        if (digitsOnly != v) {
          controller.text = digitsOnly;
          controller.selection = TextSelection.collapsed(
            offset: digitsOnly.length,
          );
        }
        onChanged(digitsOnly);
      },
    );
  }
}
