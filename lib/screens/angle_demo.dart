import 'package:flutter/material.dart';
import 'dart:math';

class AngleDemoScreen extends StatefulWidget {
  const AngleDemoScreen({super.key});

  @override
  State<AngleDemoScreen> createState() => _AngleDemoScreenState();
}

class _AngleDemoScreenState extends State<AngleDemoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  double _angle = 30.0; // 角度值，单位度

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _angleAnimation = Tween<double>(begin: 20.0, end: 80.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _angle = _angleAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('线面角演示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: _LinePlaneAnglePainter(_angle),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '线面角: ${_angle.toStringAsFixed(1)}°',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _angle,
              min: 0,
              max: 90,
              divisions: 90,
              label: _angle.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _angle = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '线面角定义: 一条直线与它在平面内的射影所成的锐角。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '图中: 直线AB与平面α相交于点B，点A在平面α上的射影是点C，∠ABC就是线面角。',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isAnimating) {
                      _controller.stop();
                    } else {
                      _controller.repeat(reverse: true);
                    }
                  },
                  child: Text(_controller.isAnimating ? '暂停动画' : '开始动画'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('返回'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LinePlaneAnglePainter extends CustomPainter {
  final double angle;

  _LinePlaneAnglePainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final planeWidth = 150.0;
    final planeHeight = 100.0;

    // 绘制平面 (矩形)
    final planeRect = Rect.fromCenter(
      center: center,
      width: planeWidth,
      height: planeHeight,
    );
    final planePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(planeRect, planePaint);

    // 平面边框
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(planeRect, borderPaint);

    // 平面标注 "α"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'α',
        style: TextStyle(color: Colors.blue, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center + const Offset(60, -40));

    // 平面的法线 (虚线)
    final dashPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _drawDashedLine(
      canvas,
      center,
      center + const Offset(0, -80),
      dashPaint,
    );

    // 直线 AB (与平面相交)
    final angleRad = angle * pi / 180;
    final lineLength = 100.0;
    final lineEnd = Offset(
      center.dx + lineLength * cos(angleRad),
      center.dy - lineLength * sin(angleRad),
    );

    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;
    canvas.drawLine(center, lineEnd, linePaint);

    // 标注点 A, B
    _drawPoint(canvas, center, 'B', Colors.red);
    _drawPoint(canvas, lineEnd, 'A', Colors.red);

    // 射影线 BC
    final projectionPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;
    final projectionEnd = Offset(lineEnd.dx, center.dy);
    canvas.drawLine(center, projectionEnd, projectionPaint);
    _drawPoint(canvas, projectionEnd, 'C', Colors.green);

    // 绘制角度弧线
    final arcRect = Rect.fromCircle(center: center, radius: 30);
    final arcPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      arcRect,
      -pi / 2, // 从垂直向上开始
      -angleRad, // 负角度表示顺时针
      false,
      arcPaint,
    );

    // 角度标注
    final angleTextPainter = TextPainter(
      text: TextSpan(
        text: '${angle.toStringAsFixed(0)}°',
        style: const TextStyle(color: Colors.orange, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    angleTextPainter.layout();
    final angleTextOffset = Offset(
      center.dx + 35 * cos(-angleRad / 2 - pi / 2),
      center.dy + 35 * sin(-angleRad / 2 - pi / 2),
    );
    angleTextPainter.paint(canvas, angleTextOffset);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final distance = (end - start).distance;
    final steps = (distance / (dashWidth + dashSpace)).floor();
    final direction = (end - start) / distance;

    for (int i = 0; i < steps; i++) {
      final dashStart = start + direction * (i * (dashWidth + dashSpace));
      final dashEnd = dashStart + direction * dashWidth;
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  void _drawPoint(Canvas canvas, Offset point, String label, Color color) {
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, 5, pointPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, point + const Offset(8, -8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}