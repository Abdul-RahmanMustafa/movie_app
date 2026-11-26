
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/auth_styles.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.iconPath,
    this.obscureIconPath,
    this.keyboardType,
    this.obscure = false,
    this.validator,
  }) : assert(icon != null || iconPath != null);

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final String? iconPath;
  final String? obscureIconPath;
  final TextInputType? keyboardType;
  final bool obscure;
  final String? Function(String?)? validator;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool visible = false;

  Widget _buildAssetIcon(String path, {double size = 22}) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscure && !visible,
      validator: widget.validator,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: widget.iconPath != null
            ? Padding(
          padding: const EdgeInsets.all(14),
          child: _buildAssetIcon(widget.iconPath!),
        )
            : Icon(
          widget.icon,
          color: Colors.white,
          size: 23,
        ),
        suffixIcon: widget.obscure
            ? IconButton(
          onPressed: () {
            setState(() => visible = !visible);
          },
          icon: visible
              ? const Icon(
            Icons.visibility_outlined,
            color: Colors.white,
            size: 22,
          )
              : widget.obscureIconPath != null
              ? _buildAssetIcon(
            widget.obscureIconPath!,
            size: 22,
          )
              : const Icon(
            Icons.visibility_off,
            color: Colors.white,
            size: 22,
          ),
        )
            : null,
        filled: true,
        fillColor: authSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: authYellow,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
