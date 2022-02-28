import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flying_emoji/src/foundation/flying_emoji_object.dart';

class FlyingEmojiController implements Listenable {
  FlyingEmojiController({
    required this.vsync,
  })  : flyingEmojis = [],
        _listeners = [],
        _random = Random();

  /// Provider for the ticker that updates the controller.
  final TickerProvider vsync;

  final List<FlyingEmojiObject> flyingEmojis;

  Size windowSize = Size.zero;

  final Random _random;

  late final Ticker _ticker;

  void start() {
    _ticker = vsync.createTicker(_update)..start();
  }

  final List<VoidCallback> _listeners;

  /// Set start point for flying
  Point<double>? startPoint;

  double _iconSize = 14;
  double get iconSize => _iconSize;
  set iconSize(double value) {
    if (value < 14) {
      _iconSize = 14;
      return;
    }
    if (value > 100) {
      _iconSize = 100;
      return;
    }
    _iconSize = value;
  }

  @override
  void addListener(listener) {
    assert(!_listeners.contains(listener));

    _listeners.add(listener);
  }

  @override
  void removeListener(listener) {
    assert(_listeners.contains(listener));

    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
    _ticker.dispose();
  }

  void _update(Duration elapsedDuration) {
    if (windowSize == Size.zero) {
      // We need to wait until we have the size.
      return;
    }

    for (final flyingEmoji in flyingEmojis) {
      flyingEmoji.update();
    }

    flyingEmojis.removeWhere((element) {
      final targetReached = element.distanceTraveled >= element.targetDistance;
      if (!targetReached) return false;

      return targetReached;
    });

    for (final listener in List.of(_listeners)) {
      if (!_listeners.contains(listener)) continue;
      listener.call();
    }
  }

  void spawnEmoji(Point<double> target) {
    final flyingEmoji = FlyingEmojiObject(
      random: _random,
      start: startPoint ??
          Point(
            windowSize.width / 2,
            windowSize.height,
          ),
      target: target,
      size: iconSize,
    );
    flyingEmojis.add(flyingEmoji);
  }
}
