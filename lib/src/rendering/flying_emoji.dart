import 'package:flutter/rendering.dart';
import 'package:flying_emoji/src/foundation/controller.dart';

class RenderFlyingEmoji extends RenderBox {
  RenderFlyingEmoji({
    required FlyingEmojiController controller,
  }) : _controller = controller;

  /// The controller that manages the fireworks and tells the render box what
  /// and when to paint.
  FlyingEmojiController get controller => _controller;
  FlyingEmojiController _controller;

  set controller(FlyingEmojiController value) {
    if (controller == value) return;

    // Detach old controller.
    _controller.removeListener(_handleControllerUpdate);
    _controller = value;

    // Attach new controller.
    controller.addListener(_handleControllerUpdate);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    controller.addListener(_handleControllerUpdate);
  }

  @override
  void detach() {
    controller.removeListener(_handleControllerUpdate);

    super.detach();
  }

  void _handleControllerUpdate() {
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();

    controller.windowSize = size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {}

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    // if (event is PointerHoverEvent) {
    //   controller.spawnEmoji(Point(
    //     event.localPosition.dx,
    //     event.localPosition.dy,
    //   ));
    // }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..clipRect(offset & size);
    //..translate(offset.dx, offset.dy);

    _drawEmojis(canvas);

    canvas.restore();
  }

  void _drawEmojis(Canvas canvas) {
    for (final flyingEmoji in controller.flyingEmojis) {
      final textPainter = TextPainter(
        text:
            TextSpan(text: '❤️', style: TextStyle(fontSize: flyingEmoji.size)),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      textPainter.paint(
          canvas,
          Offset(
            flyingEmoji.position.x,
            flyingEmoji.position.y,
          ));
      canvas.restore();
    }
  }
}
