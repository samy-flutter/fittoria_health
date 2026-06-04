import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeTeal = isDark ? AppColors.darkTeal : AppColors.lightTeal;

    final errorColor = Theme.of(context).colorScheme.error;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              _hasError = false;
            });
          }

          widget.onChanged?.call(value);
        },
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 14.5,
        ),

        validator: (value) {
          final result = widget.validator?.call(value);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _hasError = result != null;
              });
            }
          });

          return result;
        },

        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,

          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  size: 19,
                  color: _hasError
                      ? errorColor
                      : _isFocused
                      ? activeTeal
                      : (isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted),
                )
              : null,

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 19,
                    color: _hasError
                        ? errorColor
                        : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,

          alignLabelWithHint: true,

          labelStyle: TextStyle(
            color: _hasError
                ? errorColor
                : _isFocused
                ? activeTeal
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            fontSize: 13.5,
            fontWeight: _isFocused ? FontWeight.w600 : FontWeight.normal,
          ),

          floatingLabelStyle: TextStyle(
            color: _hasError ? errorColor : activeTeal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
