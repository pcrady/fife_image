import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SelectedImagePaint extends StatefulWidget {
  final String url;

  const SelectedImagePaint({
    required this.url,
    super.key,
  });

  @override
  State<SelectedImagePaint> createState() => _SelectedImagePaintState();
}

class _SelectedImagePaintState extends State<SelectedImagePaint> {
  double initialWidth = 1.0;
  CustomRegionSelectionPainter painter = CustomRegionSelectionPainter();
  void onEnter(PointerEnterEvent event) {}
  void onExit(PointerExitEvent event) {}
  void onHover(PointerHoverEvent event) {}
  void onPanStart(DragStartDetails details) {
    setState(() => painter.clearPoints());
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() => painter.addPoint(details.localPosition));
  }

  void onPanEnd(DragEndDetails details) {
    painter.setUnscaledPoints();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialWidth = MediaQuery.of(context).size.width;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var mediaQuery = MediaQuery.of(context);
    final scale = mediaQuery.size.width / initialWidth;
    painter.scalePoints(scale);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          child: GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: Container(
              height: constraints.widthConstraints().maxWidth,
              width: constraints.heightConstraints().maxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.url),
                  fit: BoxFit.cover,
                ),
              ),
              child: CustomPaint(
                painter: painter,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomRegionSelectionPainter extends CustomPainter {
  List<Offset> points = [];
  List<Offset> unscaledPoints = [];

  void addPoint(Offset point) {
    points.add(point);
  }

  void clearPoints() {
    points = [];
  }

  void setUnscaledPoints() {
    unscaledPoints = List.from(points);
  }

  void scalePoints(double scale) {
    List<Offset> scaledPoints = [];

    for (Offset point in unscaledPoints) {
      final scaledPoint = Offset(
        point.dx * scale,
        point.dy * scale,
      );
      scaledPoints.add(scaledPoint);
    }
    points = scaledPoints;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    if (points.isNotEmpty) {
      for (int i = 0; i < points.length - 1; i++) {
        Offset point1 = points[i];
        Offset point2 = points[i + 1];
        canvas.drawLine(point1, point2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomRegionSelectionPainter oldDelegate) {
    return true;
  }
}
