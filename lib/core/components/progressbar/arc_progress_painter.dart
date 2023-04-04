import 'dart:math';

import 'package:flutter/material.dart';

class GradiendArcProgressController {
  GradiendArcProgressController(
      {required this.iconHeight, required this.iconWidth});
  final double iconWidth, iconHeight;
  double? _locationX, _locationY;

  void setLocation(double offsetX, double offsetY) {
    _locationX = offsetX - (iconWidth / 2);
    _locationY = offsetY - (iconHeight / 2);
  }

  double get left => _locationX ?? 0;
  double get top => _locationY ?? 0;
}

class GradiendArcProgress extends CustomPainter {
  final int progress;
  final int minutes;
  final Color startColor;
  final Color endColor;
  final double width;
  GradiendArcProgressController? controller;

  GradiendArcProgress(
      {required this.progress,
      required this.startColor,
      required this.endColor,
      required this.width,
      required this.minutes,
      this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradiend = SweepGradient(
        startAngle: 3 * pi / 2,
        endAngle: 7 * pi / 2,
        tileMode: TileMode.repeated,
        colors: [endColor, startColor, endColor]);
    final fullCircle = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffdfe8f9)
      ..strokeWidth = width;
    final shadow = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..strokeWidth = width - 4;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = gradiend.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (width / 2);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress / (minutes * 60);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        360, false, fullCircle);
    /* canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle + 1, false, paint);*/
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle + 0.04, false, shadow);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, paint);

    if (controller != null) {
      final startX = center.dx + radius * cos(startAngle);
      final startY = center.dy + radius * sin(startAngle);
      controller!.setLocation(startX, startY);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
