import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class Lab4VariantScreen extends StatefulWidget {
  const Lab4VariantScreen({super.key});

  @override
  State<Lab4VariantScreen> createState() => _Lab4VariantScreenState();
}

class _Lab4VariantScreenState extends State<Lab4VariantScreen> {
  // Оси заданы в процентах относительно половины короткой стороны холста
  double aFactor = 0.8; // полуось a
  double bFactor = 0.5; // полуось b
  int n = 12; // количество окружностей
  double rFactor = 0.08; // радиус окружности относительно половины короткой стороны
  double rotation = 0.0; // дополнительный поворот (в радианах)

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Lab 4 · Variant'),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            SizedBox(
              height: 280,
              child: CustomPaint(
                painter: _EllipseCirclesPainter(
                  aFactor: aFactor,
                  bFactor: bFactor,
                  n: n,
                  rFactor: rFactor,
                  rotation: rotation,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('Axes (a, b)'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: Text('a = ${(aFactor * 100).round()}%'),
                  child: CupertinoSlider(
                    value: aFactor,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (v) => setState(() => aFactor = v),
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('b = ${(bFactor * 100).round()}%'),
                  child: CupertinoSlider(
                    value: bFactor,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (v) => setState(() => bFactor = v),
                  ),
                ),
              ],
            ),
            CupertinoFormSection.insetGrouped(
              header: const Text('Circles (n, r)'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: Text('n = $n'),
                  child: CupertinoSlider(
                    value: n.toDouble(),
                    min: 3,
                    max: 60,
                    divisions: 57,
                    onChanged: (v) => setState(() => n = v.round()),
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('r = ${(rFactor * 100).round()}%'),
                  child: CupertinoSlider(
                    value: rFactor,
                    min: 0.02,
                    max: 0.2,
                    onChanged: (v) => setState(() => rFactor = v),
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

class _EllipseCirclesPainter extends CustomPainter {
  final double aFactor;
  final double bFactor;
  final int n;
  final double rFactor;
  final double rotation;
  final Color color;

  _EllipseCirclesPainter({
    required this.aFactor,
    required this.bFactor,
    required this.n,
    required this.rFactor,
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double shortest = math.min(size.width, size.height);
    final double half = shortest * 0.5;
    final double a = half * aFactor;
    final double b = half * bFactor;
    final double r = half * rFactor;

    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw ellipse outline (subtle)
    final Paint outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withOpacity(0.35);

    final Path ellipse = Path();
    const int segments = 120;
    for (int i = 0; i <= segments; i++) {
      final double t = (i / segments) * math.pi * 2;
      final double xr = a * math.cos(t);
      final double yr = b * math.sin(t);
      final double xr2 = xr * math.cos(rotation) - yr * math.sin(rotation);
      final double yr2 = xr * math.sin(rotation) + yr * math.cos(rotation);
      final Offset p = center + Offset(xr2, yr2);
      if (i == 0) {
        ellipse.moveTo(p.dx, p.dy);
      } else {
        ellipse.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(ellipse, outline);

    // Draw circles equally spaced along ellipse by parameter t
    final Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color;

    for (int i = 0; i < n; i++) {
      final double t = (i / n) * math.pi * 2;
      final double xr = a * math.cos(t);
      final double yr = b * math.sin(t);
      final double xr2 = xr * math.cos(rotation) - yr * math.sin(rotation);
      final double yr2 = xr * math.sin(rotation) + yr * math.cos(rotation);
      final Offset centerCircle = center + Offset(xr2, yr2);
      canvas.drawCircle(centerCircle, r, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EllipseCirclesPainter oldDelegate) {
    return oldDelegate.aFactor != aFactor ||
        oldDelegate.bFactor != bFactor ||
        oldDelegate.n != n ||
        oldDelegate.rFactor != rFactor ||
        oldDelegate.rotation != rotation ||
        oldDelegate.color != color;
  }
}



