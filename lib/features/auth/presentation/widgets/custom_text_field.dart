import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  // ── Design tokens ──
  static const _radius = 32.0;
  static const _textColor = Color(0xFF243B53);
  static const _hintColor = Color(0xFF8398A8);
  static const _iconColor = Color(0xFF397DAA);
  static const _fillColor = Color(0x80F7FCFF); // 50% opacity
  static const _borderColor = Color(0xFFDCEAF2);
  static const _focusColor = Color(0xFF368DC4);
  static const _errorColor = Color(0xFFC84D4D);

  /// Slots for the prefix/suffix icons. Kept compact so the text gets as much
  /// room as possible inside narrow layouts.
  static const _iconSlot = BoxConstraints(minWidth: 40, minHeight: 40);

  static OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      // letterSpacing: 0 removes the default Material 3 tracking, which makes
      // the hint noticeably wider than it needs to be.
      style: const TextStyle(color: _textColor, fontSize: 14, letterSpacing: 0),
      decoration: InputDecoration(
        hintText: hintText,
        hintMaxLines: 1,
        hintStyle: const TextStyle(
          color: _hintColor,
          fontSize: 13,
          letterSpacing: 0,
        ),
        prefixIcon: Icon(prefixIcon, color: _iconColor, size: 20),
        prefixIconConstraints: _iconSlot,
        suffixIcon: suffix,
        suffixIconConstraints: _iconSlot,
        filled: true,
        fillColor: _fillColor,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 17, 10, 17),
        border: _border(_borderColor),
        enabledBorder: _border(_borderColor),
        focusedBorder: _border(_focusColor, 1.5),
        errorBorder: _border(_errorColor),
        focusedErrorBorder: _border(_errorColor, 1.5),
      ),
    );
  }
}