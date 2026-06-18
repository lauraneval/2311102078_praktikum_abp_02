import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A panel/card widget that renders classical corner ornaments.
/// Drop-in replacement for [Card] throughout the app.
class DecorativeCard extends StatelessWidget {
  const DecorativeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.cardBg,
    this.ornamentSize = 14.0,
    this.borderRadius = 4.0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double ornamentSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.heading.withOpacity(0.3), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkAccent.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Padding(padding: padding, child: child),
          // Corner ornaments
          _Ornament(ornamentSize, Alignment.topLeft),
          _Ornament(ornamentSize, Alignment.topRight),
          _Ornament(ornamentSize, Alignment.bottomLeft),
          _Ornament(ornamentSize, Alignment.bottomRight),
        ],
      ),
    );
  }
}

class _Ornament extends StatelessWidget {
  const _Ornament(this.size, this.alignment);

  final double size;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final isTop  = alignment == Alignment.topLeft || alignment == Alignment.topRight;

    return Positioned(
      top:    isTop    ? 4  : null,
      bottom: !isTop   ? 4  : null,
      left:   isLeft   ? 4  : null,
      right:  !isLeft  ? 4  : null,
      child: CustomPaint(
        size: Size(size, size),
        painter: _OrnamentPainter(
          color: AppColors.heading.withOpacity(0.45),
          flipX: !isLeft,
          flipY: !isTop,
        ),
      ),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  const _OrnamentPainter({
    required this.color,
    required this.flipX,
    required this.flipY,
  });

  final Color color;
  final bool flipX;
  final bool flipY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    // Mirror the ornament into the correct corner
    canvas.translate(flipX ? size.width : 0, flipY ? size.height : 0);
    canvas.scale(flipX ? -1 : 1, flipY ? -1 : 1);

    final s = size.width;

    // Two straight arms
    canvas.drawLine(Offset(0, 0), Offset(s * 0.55, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, s * 0.55), paint);

    // Decorative small arc at the inner corner
    final arcRect = Rect.fromLTWH(s * 0.15, s * 0.15, s * 0.5, s * 0.5);
    canvas.drawArc(arcRect, -3.14 / 2, -3.14 / 2, false, paint);

    // Tiny dot at the very corner tip
    canvas.drawCircle(Offset.zero, 1.2, paint..style = PaintingStyle.fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_OrnamentPainter old) =>
      old.color != color || old.flipX != flipX || old.flipY != flipY;
}