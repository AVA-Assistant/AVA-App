import 'package:flutter/material.dart';

class CustomRoundedRectSliderTrackShapeCCT extends SliderTrackShape with BaseSliderTrackShape {
  final Radius trackRadius;
  const CustomRoundedRectSliderTrackShapeCCT(this.trackRadius);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.activeTrackColor);
    final Paint rightTrackPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.red,
          Colors.amber,
          Colors.white,
          Colors.blue,
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 350, 3000));
    final Paint leftTrackPaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    var activeRect = RRect.fromLTRBAndCorners(
      thumbCenter.dx - 10,
      trackRect.top - (additionalActiveTrackHeight / 2) - 10,
      thumbCenter.dx,
      trackRect.bottom + (additionalActiveTrackHeight / 2) + 10,
      topRight: trackRadius,
      bottomRight: trackRadius,
      topLeft: trackRadius,
      bottomLeft: trackRadius,
    );
    var inActiveRect = RRect.fromLTRBAndCorners(
      trackRect.left,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      topRight: trackRadius,
      bottomRight: trackRadius,
      bottomLeft: trackRadius,
      topLeft: trackRadius,
    );

    context.canvas.drawRRect(
      inActiveRect,
      rightTrackPaint,
    );
    context.canvas.drawRRect(
      activeRect,
      leftTrackPaint,
    );
  }
}
