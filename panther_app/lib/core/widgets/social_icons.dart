import 'package:flutter/material.dart';

/// Simplified Google "G" mark — four brand-colored arcs, close enough to
/// read as Google next to a "Continue with Google" label without shipping
/// the exact multi-path brand SVG.
class GoogleGIcon extends StatelessWidget {
  const GoogleGIcon({super.key, this.size = 18});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _GoogleGPainter()));
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final stroke = size.width * 0.22;
    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    const twoPi = 6.28318530718;
    const gap = 0.06;
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.35, twoPi / 4 - gap, false, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, -0.35 + twoPi / 4, twoPi / 4 - gap, false, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -0.35 + twoPi / 2, twoPi / 4 - gap, false, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -0.35 + 3 * twoPi / 4, twoPi / 4 - gap, false, paint);

    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - stroke / 2, radius - stroke * 0.2, stroke),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleGPainter oldDelegate) => false;
}

/// Microsoft's four-square mark.
class MicrosoftIcon extends StatelessWidget {
  const MicrosoftIcon({super.key, this.size = 18});
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = (size - 2) / 2;
    Widget sq(Color c) => Container(width: s, height: s, color: c);
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            sq(const Color(0xFFF25022)),
            const SizedBox(width: 2),
            sq(const Color(0xFF7FBA00)),
          ]),
          const SizedBox(height: 2),
          Row(mainAxisSize: MainAxisSize.min, children: [
            sq(const Color(0xFF00A4EF)),
            const SizedBox(width: 2),
            sq(const Color(0xFFFFB900)),
          ]),
        ],
      ),
    );
  }
}
