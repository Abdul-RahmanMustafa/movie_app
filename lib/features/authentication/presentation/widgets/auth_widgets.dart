import 'package:flutter/material.dart';

const authYellow = Color(0xFFFFBB00);
const authBackground = Color(0xFF121312);
const authSurface = Color(0xFF282A28);

class AuthField extends StatefulWidget {
  const AuthField({super.key, required this.controller, required this.hint,
    required this.icon, this.keyboardType, this.obscure = false, this.validator});
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscure;
  final String? Function(String?)? validator;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    keyboardType: widget.keyboardType,
    obscureText: widget.obscure && !visible,
    validator: widget.validator,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(
      hintText: widget.hint,
      hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
      prefixIcon: Icon(widget.icon, color: Colors.white, size: 23),
      suffixIcon: widget.obscure ? IconButton(
        icon: Icon(visible ? Icons.visibility_outlined : Icons.visibility_off,
          color: Colors.white, size: 22),
        onPressed: () => setState(() => visible = !visible),
      ) : null,
      filled: true,
      fillColor: authSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: authYellow, width: 1.4)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
    ),
  );
}

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.text, required this.onPressed, this.leading});
  final String text;
  final VoidCallback onPressed;
  final Widget? leading;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: authYellow, foregroundColor: Colors.black,
        elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (leading != null) ...[leading!, const SizedBox(width: 10)],
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});
  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}
class _LanguageToggleState extends State<LanguageToggle> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(border: Border.all(color: authYellow, width: 2), borderRadius: BorderRadius.circular(30)),
    child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(2, (i) => InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => setState(() => selected = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(color: selected == i ? authYellow.withValues(alpha: .2) : Colors.transparent, borderRadius: BorderRadius.circular(30)),
        child: Text(i == 0 ? '🇺🇸' : '🇪🇬', style: const TextStyle(fontSize: 23)),
      ),
    ))),
  );
}

String? requiredValidator(String? value) => value == null || value.trim().isEmpty ? 'This field is required' : null;
String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) return 'Enter a valid email';
  return null;
}
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Use at least 8 characters';
  return null;
}

void showPending(BuildContext context, String action) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$action will be available after backend integration.')));
}
