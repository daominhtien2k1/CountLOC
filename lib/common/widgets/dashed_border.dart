import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    this.color = Colors.black26,
    this.dashWidth = 3,
    this.dashSpace = 3,
    this.strokeWidth = 1,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Rect outerRect = Offset.zero & size;
    final RRect outerRRect = RRect.fromRectAndCorners(
      outerRect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final double topY = outerRRect.top;
    final double bottomY = outerRRect.bottom;
    final double rightX = outerRRect.right;
    final double leftX = outerRRect.left;

    // Draw top dashed line
    for (double i = leftX; i < rightX; i += dashWidth + dashSpace) {
      final startX = i;
      final endX = startX + dashWidth;
      canvas.drawLine(
        Offset(startX, topY),
        Offset(endX, topY),
        paint,
      );
    }

    // Draw bottom dashed line
    for (double i = leftX; i < rightX; i += dashWidth + dashSpace) {
      final startX = i;
      final endX = startX + dashWidth;
      canvas.drawLine(
        Offset(startX, bottomY),
        Offset(endX, bottomY),
        paint,
      );
    }

    // Draw left dashed line
    for (double i = topY; i < bottomY; i += dashWidth + dashSpace) {
      final startY = i;
      final endY = startY + dashWidth;
      canvas.drawLine(
        Offset(leftX, startY),
        Offset(leftX, endY),
        paint,
      );
    }

    // Draw right dashed line
    for (double i = topY; i < bottomY; i += dashWidth + dashSpace) {
      final startY = i;
      final endY = startY + dashWidth;
      canvas.drawLine(
        Offset(rightX, startY),
        Offset(rightX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class DashedBorderContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Widget child;

  DashedBorderContainer({
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: DashedBorderPainter(
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}