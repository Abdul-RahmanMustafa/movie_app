
import 'package:flutter/material.dart';

import '../theme/auth_styles.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.isLoading = false,
    this.fontSize = 16,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? leading;
  final bool isLoading;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: authYellow,
          foregroundColor: Colors.black,
          disabledBackgroundColor: authYellow,
          disabledForegroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.black,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
