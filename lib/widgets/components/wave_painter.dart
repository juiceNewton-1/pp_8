import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  const WavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withOpacity(animationValue)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (var i = 0; i < 2; i++) {
      final waveRadius = (size.width * animationValue * 1.5) * (i + 1) ;
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}