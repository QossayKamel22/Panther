import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The PANTHER brand mark, in-app: a theme-aware vector logo, never
/// rasterized. Two fixed-color SVGs (assets/branding/panther_glyph_*.svg)
/// swap based on the active [Brightness] so the glyph always reads against
/// its background — the white glyph on dark surfaces, the black glyph on
/// light ones — with no plate, tint, or approximation of the source art.
///
/// This is the in-app mark only. The neon/glow raster mark
/// (assets/branding/app_icon.png) is external-facing — app icons and
/// launcher art — and is never used inside the running app's UI.
class PantherMark extends StatelessWidget {
  const PantherMark({super.key, this.size = 28, this.glow = false});

  final double size;

  /// Adds a soft blue backdrop glow behind the mark — a page-level
  /// decoration only (e.g. the welcome screen hero), never baked into or
  /// altering the SVG asset itself.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asset = isDark
        ? 'assets/branding/panther_glyph_white.svg'
        : 'assets/branding/panther_glyph_black.svg';

    final mark = SvgPicture.asset(asset, width: size, height: size, fit: BoxFit.contain);

    if (!glow) return mark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 1.7,
            height: size * 1.7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x553B82F6), Color(0x003B82F6)],
              ),
            ),
          ),
          mark,
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
