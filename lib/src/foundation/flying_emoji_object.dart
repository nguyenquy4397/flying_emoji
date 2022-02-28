import 'dart:math';

class FlyingEmojiObject {
  FlyingEmojiObject({
    required Random random,
    required this.start,
    required this.target,
    required this.size,
  })  : targetDistance = target.distanceTo(start),
        angle = atan2(target.y - start.y, target.x - start.x),
        position = start;

  final Point<double> start;
  final Point<double> target;
  Point<double> position;

  final double angle;
  final double targetDistance;
  double distanceTraveled = 0;

  double velocity = 1;
  final double acceleration = 1.025;

  final double size;

  void update() {
    velocity *= acceleration;

    final vp = Point(cos(angle) * velocity, sin(angle) * velocity);
    distanceTraveled = (position + vp).distanceTo(start);

    if (distanceTraveled < targetDistance) {
      position += vp;
    }
  }
}
