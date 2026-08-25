import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.autofocus = false,
    this.onSubmitted,
    this.textInputAction,
    this.prefixIcon,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofocus: autofocus,
      enabled: enabled,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
      ),
    );
  }
}
