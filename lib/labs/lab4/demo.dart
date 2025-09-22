import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class Lab4DemoScreen extends StatefulWidget {
  const Lab4DemoScreen({super.key});

  @override
  State<Lab4DemoScreen> createState() => _Lab4DemoScreenState();
}

class _Lab4DemoScreenState extends State<Lab4DemoScreen> {
  int sides = 6; // 3..12
  double sizeFactor = 0.6; // 0.1..1.0 (relative to shortest side)
  double rotation = 0.0; // radians 0..2pi

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Lab 4 · Demo'),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            SizedBox(
              height: 280,
              child: CustomPaint(
                painter: _PolygonPainter(
                  sides: sides,
                  sizeFactor: sizeFactor,
                  rotation: rotation,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('Sides'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: Text('$sides'),
                  child: CupertinoSlider(
                    value: sides.toDouble(),
                    min: 3,
                    max: 12,
                    divisions: 9,
                    onChanged: (v) => setState(() => sides = v.round()),
                  ),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('Size'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: Text('${(sizeFactor * 100).round()}%'),
                  child: CupertinoSlider(
                    value: sizeFactor,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (v) => setState(() => sizeFactor = v),
                  ),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('Rotation'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: Text('${(rotation * 180 / math.pi).round()}°'),
                  child: CupertinoSlider(
                    value: rotation,
                    min: 0,
                    max: math.pi * 2,
                    onChanged: (v) => setState(() => rotation = v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final int sides;
  final double sizeFactor;
  final double rotation; // radians
  final Color color;

  _PolygonPainter({
    required this.sides,
    required this.sizeFactor,
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = color;

    final double shortest = math.min(size.width, size.height);
    final double radius = shortest * 0.5 * sizeFactor;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final Path path = Path();

    final double angle = (math.pi * 2) / sides;
    final double startRadians = rotation;
    final double x0 = radius * math.cos(startRadians) + center.dx;
    final double y0 = radius * math.sin(startRadians) + center.dy;
    path.moveTo(x0, y0);

    for (int i = 1; i <= sides; i++) {
      final double x = radius * math.cos(startRadians + angle * i) + center.dx;
      final double y = radius * math.sin(startRadians + angle * i) + center.dy;
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PolygonPainter oldDelegate) {
    return oldDelegate.sides != sides ||
        oldDelegate.sizeFactor != sizeFactor ||
        oldDelegate.rotation != rotation ||
        oldDelegate.color != color;
  }
}


