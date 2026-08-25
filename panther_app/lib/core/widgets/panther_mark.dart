import 'package:flutter/material.dart';

/// The PANTHER brand mark — the metallic "P"/panther-head glyph, always
/// rendered on its own small dark plate with a soft blue glow behind it.
///
/// The source artwork (assets/branding/panther_mark.png) carves the
/// panther's face out of the glyph as transparent negative space that's
/// open to the glyph's outer silhouette (not a sealed hole), so it only
/// reads correctly against a dark backdrop — hence the fixed plate here
/// rather than tinting/theming the mark itself. This keeps the glyph
/// legible and on-brand everywhere: light mode, dark mode, any surface.
class PantherMark extends StatelessWidget {
  const PantherMark({super.key, this.size = 28, this.glow = true});

  final double size;
  final bool glow;

  static const _plateColor = Color(0xFF05070C);
  static const _glowColor = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (glow)
            Container(
              width: size * 1.55,
              height: size * 1.55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x553B82F6), Color(0x003B82F6)],
                ),
              ),
            ),
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.16),
            decoration: BoxDecoration(
              color: _plateColor,
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: [
                BoxShadow(
                  color: _glowColor.withValues(alpha: 0.35),
                  blurRadius: size * 0.25,
                  spreadRadius: size * 0.01,
                ),
              ],
            ),
            child: Image.asset('assets/branding/panther_mark.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

/// Full brand lockup: glyph + wordmark, for headers, splash and login.
class PantherWordmark extends StatelessWidget {
  const PantherWordmark({
    super.key,
    this.markSize = 28,
    this.fontSize = 16,
    this.color,
  });

  final double markSize;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PantherMark(size: markSize),
        SizedBox(width: markSize * 0.4),
        Text(
          'PANTHER',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: resolved,
          ),
        ),
      ],
    );
  }
}
