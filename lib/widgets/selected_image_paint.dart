import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
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
  double currentWidth = 1.0;
  double currentHeight = 1.0;
  CustomRegionSelectionPainter painter = CustomRegionSelectionPainter();

  List<Offset> computeRelativePoints({
    required List<Offset> absolutePoints,
  }) {
    List<Offset> relativePoints = [];
    for (Offset absolutePoint in absolutePoints) {
      final relativePoint = Offset(
        absolutePoint.dx / currentWidth,
        absolutePoint.dy / currentHeight,
      );
      relativePoints.add(relativePoint);
    }
    return relativePoints;
  }

  List<Offset> computeAbsolutePoints({
    required List<Offset> relativePoints,
  }) {
    List<Offset> absolutePoints = [];
    for (Offset relativePoint in relativePoints) {
      final absolutePoint = Offset(
        relativePoint.dx * currentWidth,
        relativePoint.dy * currentHeight,
      );
      absolutePoints.add(absolutePoint);
    }
    return absolutePoints;
  }

  void onEnter(PointerEnterEvent event) {}
  void onExit(PointerExitEvent event) {}
  void onHover(PointerHoverEvent event) {}
  void onPanStart(DragStartDetails details) {
    setState(() => painter.clearPoints());
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() => painter.addPoint(details.localPosition));
  }

  void onPanEnd(
    DragEndDetails details,
  ) {
    if (painter.points.isNotEmpty) {
      setState(() => painter.addPoint(painter.points.first));
    }
    final relativePoints = computeRelativePoints(absolutePoints: painter.points);
    final images = ref.read(imagesProvider.notifier);
    images.updateSelection(image: widget.image, selection: relativePoints);
    painter.setUnscaledPoints();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialWidth = MediaQuery.of(context).size.width;
    });

    ref.listenManual(appDataProvider, (previous, next) {
      final relativePoints = next.selectedImage?.relativeSelectionCoordinates;
      if (relativePoints != null) {
        final absolutePoints = computeAbsolutePoints(relativePoints: relativePoints);
        painter.setInitialPoints(absolutePoints);
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

  // TODO BUG - draw path, switch image, resize screen
  @override
  Widget build(BuildContext context) {
    ref.watch(imagesProvider);
    logger.w(widget.image.hashCode);

    return LayoutBuilder(
      builder: (_, constraints) {
        currentWidth = constraints.widthConstraints().maxWidth;
        currentHeight = constraints.widthConstraints().maxWidth;

        return MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          child: GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: Container(
              // TODO this is not good fix this to make it work with non square images
              height: currentWidth,
              width: currentWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:  CachedNetworkImageProvider(
                    widget.image.url,
                    cacheKey: widget.image.md5Hash,
                    errorListener: (error) {
                      logger.e(error);
                    },
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: CustomPaint(painter: painter),
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
    unscaledPoints = List.from(initialPoints);
  }

  void addPoint(Offset point) {
    points.add(point);
  }

  void clearPoints() {
    points = [];
    unscaledPoints = [];
  }

  void setUnscaledPoints() {
    unscaledPoints = List.from(points);
  }

  List<Offset> scalePoints(double scale) {
    List<Offset> scaledPoints = [];

    for (Offset point in unscaledPoints) {
      final scaledPoint = Offset(
        point.dx * scale,
        point.dy * scale,
      );
      scaledPoints.add(scaledPoint);
    }
    points = scaledPoints;
    return points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

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
