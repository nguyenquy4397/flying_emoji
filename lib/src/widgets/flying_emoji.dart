import 'package:flutter/widgets.dart';
import 'package:flying_emoji/src/foundation/controller.dart';
import 'package:flying_emoji/src/rendering/flying_emoji.dart';

class FlyingEmoji extends LeafRenderObjectWidget {
  const FlyingEmoji({
    Key? key,
    required this.controller,
  }) : super(key: key);

  /// The controller that manages the fireworks and tells the render box what
  /// and when to paint.
  final FlyingEmojiController controller;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFlyingEmoji(
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderFlyingEmoji renderObject) {
    renderObject.controller = controller;
  }
}
