import 'package:flutter/material.dart';

import '../theme/auth_styles.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: authYellow, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          2,
          (i) => InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => setState(() => selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: selected == i
                    ? authYellow.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                i == 0 ? '🇺🇸' : '🇪🇬',
                style: const TextStyle(fontSize: 23),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
