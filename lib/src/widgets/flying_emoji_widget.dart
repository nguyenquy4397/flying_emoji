import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../flying_emoji.dart';

/// This widget wrap flying emoji with controller
/// For start and increase size emoji when hold button or multi-pressed:
/// - Button with onPressed call controller.onStart
/// - Wrap this button into GestureDetector with:
///   + onTapDown call controller.onTapDown
///   + onTapCancel call controller.onTapCancel

class FlyingEmojiWidget extends StatefulWidget {
  const FlyingEmojiWidget({
    Key? key,
    required this.keyForButton,
    required this.controller,
  }) : super(key: key);

  /// This GlobalKey for detect position when click button
  final GlobalKey keyForButton;
  final FlyingEmojiWidgetController controller;

  @override
  _FlyingEmojiWidgetState createState() => _FlyingEmojiWidgetState();
}

class _FlyingEmojiWidgetState extends State<FlyingEmojiWidget>
    with SingleTickerProviderStateMixin {
  late final FlyingEmojiController _controller =
      FlyingEmojiController(vsync: this)..start();

  @override
  void initState() {
    widget.controller.addListener(_handleListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleListener);
    _controller.dispose();
    super.dispose();
  }

  Timer? _timerMultiPressed;
  int _time = 0;

  Timer? _timerLongPressed;
  int _timeBetweenPressed = 10000;

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FlyingEmoji(
        controller: _controller,
      ),
    );
  }

  void _handleListener() {
    if (widget.controller.state == FlyingEmojiWidgetState.onStart) {
      _onStartFlyingEmoji();
    } else if (widget.controller.state == FlyingEmojiWidgetState.onTapCancel) {
      _onTapCancel();
    } else if (widget.controller.state == FlyingEmojiWidgetState.onTapDown) {
      _onTapDown();
    }
  }

  /// Detect position where you click button for start flying emoji
  void _getPositionOfButtonClicked() {
    var box =
        widget.keyForButton.currentContext!.findRenderObject() as RenderBox;
    var pos = box.localToGlobal(Offset(0, -_controller.iconSize));
    _controller.startPoint = Point(pos.dx, pos.dy);
  }

  /// This function for onTapDown of GestureDetector:
  /// - start timer you hold a button
  /// - finish timer between of two time you pressed the button
  void _onTapDown() {
    if (_timerMultiPressed != null) {
      _timerMultiPressed!.cancel();
    }
    _timerLongPressed = Timer.periodic(
      const Duration(milliseconds: 1),
      (timer) {
        _time += 1;
      },
    );
  }

  /// This function for onTapCancel of GestureDetector:
  /// - finish timer you hold button
  /// - start timer between of two time you pressed the button
  void _onTapCancel() {
    if (_timerLongPressed != null) {
      _timerLongPressed!.cancel();
      _time = 0;
    }
    _timerMultiPressed = Timer.periodic(
      const Duration(milliseconds: 1),
      (timer) {
        _timeBetweenPressed += 1;
      },
    );
  }

  /// Launch the emoji with the size base on:
  /// - if you hold the button, the size will increase
  /// - if you multi-pressed button, the size will increase (timer between of
  ///   two time pressed is < 100)
  void _onStartFlyingEmoji() {
    if (_timeBetweenPressed < 100) {
      _controller.iconSize += 5;
    } else {
      _controller.iconSize = 14.0 * (1 + _time / 100.0);
    }
    _timeBetweenPressed = 0;
    _getPositionOfButtonClicked();
    _controller.spawnEmoji(
      Point(
        _random.nextDouble() * _controller.windowSize.width,
        0,
      ),
    );
  }
}

class FlyingEmojiWidgetController extends ChangeNotifier {
  FlyingEmojiWidgetController();

  FlyingEmojiWidgetState _state = FlyingEmojiWidgetState.none;
  FlyingEmojiWidgetState get state => _state;

  void onStart() {
    _state = FlyingEmojiWidgetState.onStart;
    notifyListeners();
  }

  void onTapDown() {
    _state = FlyingEmojiWidgetState.onTapDown;
    notifyListeners();
  }

  void onTapCancel() {
    _state = FlyingEmojiWidgetState.onTapCancel;
    notifyListeners();
  }
}

enum FlyingEmojiWidgetState { onStart, onTapDown, onTapCancel, none }
