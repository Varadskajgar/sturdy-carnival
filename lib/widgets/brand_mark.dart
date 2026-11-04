import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: compact ? 30 : 36, height: compact ? 30 : 36,
        decoration: BoxDecoration(color: AppTheme.ink, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.bolt_rounded, color: AppTheme.lime, size: 22),
      ),
      const SizedBox(width: 9),
      RichText(text: TextSpan(
        style: TextStyle(fontSize: compact ? 17 : 20, fontWeight: FontWeight.w800, letterSpacing: -0.8),
        children: const [
          TextSpan(text: 'Realistic ', style: TextStyle(color: AppTheme.ink)),
          TextSpan(text: 'Mart', style: TextStyle(color: Color(0xFF78A923))),
        ],
      )),
    ],
  );
}
