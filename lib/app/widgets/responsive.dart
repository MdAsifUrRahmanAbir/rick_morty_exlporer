import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  /// Mobile breakpoint (usually <= 600)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  /// Tablet breakpoint (usually >= 600)
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return tablet;
        }
        return mobile;
      },
    );
  }
}
