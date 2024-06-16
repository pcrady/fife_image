import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImagePaint extends ConsumerStatefulWidget {
  final AbstractImage image;

  const SelectedImagePaint({
    required this.image,
    super.key,
  });

  @override
  ConsumerState<SelectedImagePaint> createState() => _SelectedImagePaintState();
}

class _SelectedImagePaintState extends ConsumerState<SelectedImagePaint> {
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
    widget.image.selectionRegion = List.from(painter.points);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialWidth = MediaQuery.of(context).size.width;
    });

    ref.listenManual(appDataProvider, (previous, next) {
      if (next.selectedImage?.selectionRegion != null) {
        painter.setInitialPoints(next.selectedImage!.selectionRegion!);
      } else {
        painter.clearPoints();
      }
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
                  image: NetworkImage(widget.image.url),
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

  void setInitialPoints(List<Offset> initialPoints) {
    points = initialPoints;
  }

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
