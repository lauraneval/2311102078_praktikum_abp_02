import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Ornate fantasy-item artwork widget.
///
/// Renders [imagePath] inside a hand-drawn-style decorative frame whose
/// corner ornaments reference the scroll/fleur style seen in the Me.Mimic
/// trading-card aesthetic. Falls back to a styled placeholder when the asset
/// is unavailable (useful before the image files are dropped in).
///
/// Usage:
/// ```dart
/// ProductArtwork(imagePath: product.imagePath, size: 80)
/// ```
class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    super.key,
    required this.imagePath,
    this.size = 80,
  });

  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OrnateFramePainter(size: size),
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: _ArtworkImage(imagePath: imagePath, size: size),
          ),
        ),
      ),
    );
  }
}

// ── Image layer with watercolour-wash background ──────────────────────────────

class _ArtworkImage extends StatelessWidget {
  const _ArtworkImage({required this.imagePath, required this.size});

  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Soft watercolour-style wash behind the item
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.85,
              colors: [
                AppColors.headerBg.withOpacity(0.55),
                AppColors.cardBg.withOpacity(0.90),
              ],
            ),
          ),
        ),
        // Actual image — falls back cleanly
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _Placeholder(size: size),
        ),
      ],
    );
  }
}

// ── Placeholder shown before real art files are added ────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.auto_fix_high_outlined,
        size: size * 0.38,
        color: AppColors.heading.withOpacity(0.55),
      ),
    );
  }
}

// ── Ornate frame painter ──────────────────────────────────────────────────────
//
// Draws a rectangular frame with:
//  • A thin outer border
//  • A slightly inset inner border
//  • Elaborate scroll/fleur-de-lis corner ornaments on all four corners
//    (each composed of bezier curves + small arcs mirrored per corner)

class _OrnateFramePainter extends CustomPainter {
  const _OrnateFramePainter({required this.size});

  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;

    final borderPaint = Paint()
      ..color = AppColors.heading.withOpacity(0.70)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final accentPaint = Paint()
      ..color = AppColors.darkAccent.withOpacity(0.30)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final inset = w * 0.065;

    // Outer border
    canvas.drawRect(
      Rect.fromLTWH(inset * 0.4, inset * 0.4,
          w - inset * 0.8, h - inset * 0.8),
      borderPaint,
    );

    // Inner border (slightly inside)
    canvas.drawRect(
      Rect.fromLTWH(inset * 0.85, inset * 0.85,
          w - inset * 1.7, h - inset * 1.7),
      accentPaint,
    );

    // Corner ornaments – draw into each corner via canvas transforms
    for (final corner in _Corner.values) {
      canvas.save();
      _applyCornerTransform(canvas, corner, w, h);
      _drawOrnament(canvas, inset, borderPaint, accentPaint);
      canvas.restore();
    }
  }

  /// Translate + scale so that the ornament drawing code always works
  /// in the top-left corner; the transform mirrors it into place.
  void _applyCornerTransform(
      Canvas canvas, _Corner corner, double w, double h) {
    switch (corner) {
      case _Corner.topLeft:
        break; // identity
      case _Corner.topRight:
        canvas.translate(w, 0);
        canvas.scale(-1, 1);
      case _Corner.bottomLeft:
        canvas.translate(0, h);
        canvas.scale(1, -1);
      case _Corner.bottomRight:
        canvas.translate(w, h);
        canvas.scale(-1, -1);
    }
  }

  /// Draws one corner ornament assuming top-left origin.
  /// Uses cubic beziers + small arcs to produce a scroll/fleur look.
  void _drawOrnament(Canvas canvas, double inset, Paint line, Paint accent) {
    final s = inset * 1.6; // ornament span from corner

    // ── Main scroll arms ────────────────────────────────────────────
    final armH = Path()
      ..moveTo(inset * 0.4, inset * 0.4)
      ..lineTo(s, inset * 0.4);
    canvas.drawPath(armH, line);

    final armV = Path()
      ..moveTo(inset * 0.4, inset * 0.4)
      ..lineTo(inset * 0.4, s);
    canvas.drawPath(armV, line);

    // ── Inner bezier flourish (concave arc connecting the two arms) ──
    final flourish = Path()
      ..moveTo(s * 0.72, inset * 0.4)
      ..cubicTo(
        s * 0.55, inset * 0.4,
        inset * 0.4, s * 0.55,
        inset * 0.4, s * 0.72,
      );
    canvas.drawPath(flourish, accent);

    // ── Terminal curl at the end of each arm ────────────────────────
    _drawCurl(canvas, Offset(s, inset * 0.4), true, line);
    _drawCurl(canvas, Offset(inset * 0.4, s), false, line);

    // ── Central corner diamond dot ───────────────────────────────────
    final dotPaint = Paint()
      ..color = AppColors.heading.withOpacity(0.60)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(inset * 0.4, inset * 0.4), 1.8, dotPaint);

    // ── Tiny mid-arm tick marks (detail) ────────────────────────────
    _drawTick(canvas, Offset(s * 0.62, inset * 0.4), true, accent);
    _drawTick(canvas, Offset(inset * 0.4, s * 0.62), false, accent);
  }

  /// A small inward curl at the tip of an arm.
  void _drawCurl(Canvas canvas, Offset tip, bool horizontal, Paint paint) {
    const r = 2.5;
    final curlRect = horizontal
        ? Rect.fromCenter(
            center: Offset(tip.dx - r, tip.dy + r), width: r * 2, height: r * 2)
        : Rect.fromCenter(
            center: Offset(tip.dx + r, tip.dy - r), width: r * 2, height: r * 2);

    canvas.drawArc(
      curlRect,
      horizontal ? -math.pi / 2 : math.pi,
      math.pi,
      false,
      paint,
    );
  }

  /// A short perpendicular tick mark for additional filigree detail.
  void _drawTick(Canvas canvas, Offset pos, bool horizontal, Paint paint) {
    const half = 2.2;
    if (horizontal) {
      canvas.drawLine(
          Offset(pos.dx, pos.dy - half), Offset(pos.dx, pos.dy + half), paint);
    } else {
      canvas.drawLine(
          Offset(pos.dx - half, pos.dy), Offset(pos.dx + half, pos.dy), paint);
    }
  }

  @override
  bool shouldRepaint(_OrnateFramePainter old) => old.size != size;
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }