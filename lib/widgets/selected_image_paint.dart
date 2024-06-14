
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
  void onEnter(PointerEnterEvent event) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(event.position);
  }

  void onExit(PointerExitEvent event) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(event.position);
  }

  void onHover(PointerHoverEvent event) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(event.position);
  }


  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
  }

  void onPanEnd(DragEndDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
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
            child: RepaintBoundary(
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
                  painter: PolygonCustomPainter(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PolygonCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(PolygonCustomPainter oldDelegate) {
    return true;
  }
}