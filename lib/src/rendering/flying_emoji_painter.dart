import 'package:flutter/cupertino.dart';
import 'package:flying_emoji/flying_emoji.dart';

class FlyingEmojiPainter extends CustomPainter {
  FlyingEmojiPainter({
    required FlyingEmojiController controller,
  })  : _controller = controller,
        super(repaint: controller);

  FlyingEmojiController _controller;
  FlyingEmojiController get controller => _controller;

  set controller(FlyingEmojiController value) {
    if (controller == value) return;

    // Detach old controller.
    _controller.removeListener(_handleControllerUpdate);
    _controller = value;

    // Attach new controller.
    controller.addListener(_handleControllerUpdate);
  }

  void _handleControllerUpdate() {}

  @override
  void paint(Canvas canvas, Size size) {
    // final canvas = context.canvas
    //   ..save()
    //   ..clipRect(offset & size);

    _drawEmojis(canvas);

    //canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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
