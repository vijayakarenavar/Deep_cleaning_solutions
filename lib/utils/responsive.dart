import 'package:flutter/material.dart';

class R {
  R._();
  static double w(BuildContext ctx) => MediaQuery.sizeOf(ctx).width;
  static double h(BuildContext ctx) => MediaQuery.sizeOf(ctx).height;
  static double sp(BuildContext ctx, double size) {
    final scale = w(ctx) / 375;
    return (size * scale).clamp(size * 0.85, size * 1.2);
  }
  static double wp(BuildContext ctx, double pct) => w(ctx) * pct / 100;
}