import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  final BuildContext context;
  late double _width;
  late double _height;
  late double _diagonal;
  late bool _isTablet;

  Responsive(this.context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;

    // c2 = a2 + b2 => c = sqrt(a2 + b2)
    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    _isTablet = size.shortestSide >= 600;
  }

  static Responsive of(BuildContext context) => Responsive(context);

  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get isTablet => _isTablet;

  // Width in percentage
  double wp(double percent) => _width * percent / 100;

  // Height in percentage
  double hp(double percent) => _height * percent / 100;

  // Font size or general size based on design reference (iPhone 11 - 375x812)
  // This helps scale up/down while maintaining proportions
  double dp(double px) => _diagonal * px / 892;

  // Font size scaling
  double sp(double px) => dp(px) * (isTablet ? 0.8 : 1.0);

  // Max width for forms (useful for tablets)
  double get maxFormWidth => isTablet ? 500 : _width;
}
