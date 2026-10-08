import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;

  static const double designWidth = 402;
  static const double designHeight = 874;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _blockSizeHorizontal = screenWidth / designWidth;
    _blockSizeVertical = screenHeight / designHeight;
  }

  static double setWidth(double width) {
    return width * _blockSizeHorizontal;
  }

  static double setHeight(double height) {
    return height * _blockSizeVertical;
  }

  static double setSize(double fontSize) {
    double scale = _blockSizeHorizontal < _blockSizeVertical
        ? _blockSizeHorizontal
        : _blockSizeVertical;
    return fontSize * scale;
  }

  static double setRadius(double radius) {
    return radius * _blockSizeHorizontal;
  }
}

extension ResponsiveExtension on num {
  double get w => Responsive.setWidth(toDouble());
  double get h => Responsive.setHeight(toDouble());
  double get s => Responsive.setSize(toDouble());
  double get r => Responsive.setRadius(toDouble());
}
