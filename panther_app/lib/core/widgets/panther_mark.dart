import 'package:flutter/material.dart';

/// The PANTHER glyph — a "P" whose bowl is drawn as a panther's head in
/// profile (pointed ear, brow, jaw, glowing eye) with three speed-lines
/// trailing off the ear, redrawn as a scalable vector path from the source
/// brand mark (see assets/branding/logo_source.png) so it stays crisp at any
/// size: nav bars, list tiles, buttons — anywhere the full raster app icon
/// would be too heavy or the wrong shape.
class PantherMark extends StatelessWidget {
  const PantherMark({
    super.key,
    this.size = 28,
    this.color,
    this.glow = true,
  });

  final double size;
  final Color? color;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PantherMarkPainter(color: resolved, glow: glow),
      ),
    );
  }
}

class _PantherMarkPainter extends CustomPainter {
  _PantherMarkPainter({required this.color, required this.glow});

  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final eyeFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (glow) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 * s);
      canvas.drawCircle(Offset(66 * s, 50 * s), 5 * s, glowPaint);
    }

    // Speed lines trailing the ear.
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(4 * s, 40 * s), Offset(24 * s, 40 * s), linePaint);
    canvas.drawLine(Offset(2 * s, 48 * s), Offset(22 * s, 48 * s), linePaint);
    canvas.drawLine(Offset(4 * s, 56 * s), Offset(20 * s, 56 * s), linePaint);

    // The glyph body: P-stem merged with a panther head silhouette.
    final path = Path()
      // stem, with the small flared foot on its left edge
      ..moveTo(38 * s, 58 * s)
      ..lineTo(48 * s, 58 * s)
      ..lineTo(48 * s, 92 * s)
      ..lineTo(38 * s, 92 * s)
      ..lineTo(38 * s, 70 * s)
      ..lineTo(30 * s, 78 * s)
      ..lineTo(37 * s, 58 * s)
      ..close();
    canvas.drawPath(path, fill);

    final head = Path()
      ..moveTo(30 * s, 34 * s)
      // brow / top of ear, flat run to the right
      ..lineTo(72 * s, 34 * s)
      // curve down the back of the head into the jaw
      ..cubicTo(84 * s, 35 * s, 90 * s, 44 * s, 88 * s, 52 * s)
      // nose tip
      ..lineTo(94 * s, 58 * s)
      ..lineTo(82 * s, 60 * s)
      // chin curving back in
      ..cubicTo(78 * s, 66 * s, 68 * s, 68 * s, 60 * s, 64 * s)
      ..cubicTo(52 * s, 60 * s, 48 * s, 52 * s, 48 * s, 44 * s)
      ..lineTo(48 * s, 58 * s)
      ..lineTo(38 * s, 58 * s)
      ..lineTo(38 * s, 44 * s)
      // pointed ear notch back to start
      ..cubicTo(38 * s, 40 * s, 33 * s, 37 * s, 30 * s, 34 * s)
      ..close();
    canvas.drawPath(head, fill);

    // Eye.
    final eye = Path()
      ..moveTo(70 * s, 46 * s)
      ..lineTo(74 * s, 50 * s)
      ..lineTo(70 * s, 54 * s)
      ..lineTo(66 * s, 50 * s)
      ..close();
    canvas.drawPath(eye, eyeFill);
  }

  @override
  bool shouldRepaint(covariant _PantherMarkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.glow != glow;
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
