import 'package:flutter/material.dart';

class TheoremDemoScreen extends StatelessWidget {
  const TheoremDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('三垂线定理'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '三垂线定理',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '在平面内的一条直线，如果和这个平面的一条斜线的射影垂直，那么它也和这条斜线垂直。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: _TheoremPainter(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '定理说明：',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '• 设平面α，直线l在平面α内，直线m是平面α的一条斜线\n'
                '• 设m在平面α上的射影为m\'\n'
                '• 如果l ⊥ m\'\n'
                '• 则 l ⊥ m',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '应用：',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '三垂线定理是立体几何中证明线线垂直的重要工具，常用于求解二面角、线面角等问题。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TheoremPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final planeWidth = 200.0;
    final planeHeight = 120.0;

    // 绘制平面
    final planeRect = Rect.fromCenter(
      center: center,
      width: planeWidth,
      height: planeHeight,
    );
    final planePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(planeRect, planePaint);

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(planeRect, borderPaint);

    // 平面标注 "α"
    _drawText(canvas, center + const Offset(80, -50), 'α', Colors.blue, 20);

    // 直线 l (在平面内)
    final lStart = Offset(center.dx - 80, center.dy);
    final lEnd = Offset(center.dx + 80, center.dy);
    final lPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;
    canvas.drawLine(lStart, lEnd, lPaint);
    _drawText(canvas, lEnd + const Offset(10, 0), 'l', Colors.red, 16);

    // 斜线 m 的射影 m'
    final mProjectionStart = Offset(center.dx, center.dy - 40);
    final mProjectionEnd = Offset(center.dx, center.dy + 40);
    final projectionPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;
    canvas.drawLine(mProjectionStart, mProjectionEnd, projectionPaint);
    _drawText(canvas, mProjectionEnd + const Offset(10, 0), "m'", Colors.green, 16);

    // 斜线 m (从平面外一点到平面)
    final pointA = Offset(center.dx, center.dy - 100); // 平面外点
    final pointB = Offset(center.dx, center.dy + 20); // 与平面交点
    final mPaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 3;
    canvas.drawLine(pointA, pointB, mPaint);
    _drawText(canvas, pointA + const Offset(10, -10), 'A', Colors.purple, 16);
    _drawText(canvas, pointB + const Offset(10, 10), 'B', Colors.purple, 16);
    _drawText(canvas, pointA + const Offset(-30, -20), 'm', Colors.purple, 16);

    // 标注垂直符号
    final perpendicularPoint = Offset(center.dx, center.dy);
    _drawPerpendicularSymbol(canvas, perpendicularPoint);

    // 连接点A到射影端点
    final dashPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(pointA.dx, pointA.dy)
      ..lineTo(mProjectionStart.dx, mProjectionStart.dy);
    canvas.drawPath(path, dashPaint);
  }

  void _drawText(Canvas canvas, Offset position, String text, Color color, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  void _drawPerpendicularSymbol(Canvas canvas, Offset center) {
    final symbolSize = 15.0;
    final symbolPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2;
    canvas.drawLine(
      center + Offset(-symbolSize / 2, 0),
      center + Offset(symbolSize / 2, 0),
      symbolPaint,
    );
    canvas.drawLine(
      center + Offset(0, -symbolSize / 2),
      center + Offset(0, symbolSize / 2),
      symbolPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}