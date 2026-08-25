import 'package:flutter/widgets.dart';

/// Three-tier breakpoint system. Values chosen so a folded/split tablet and a
/// small laptop window both land where they read naturally, not just at
/// device-marketing widths.
enum DeviceClass { mobile, tablet, desktop }

class Breakpoints {
  const Breakpoints._();

  static const double tablet = 700;
  static const double desktop = 1100;

  static DeviceClass classify(double width) {
    if (width >= desktop) return DeviceClass.desktop;
    if (width >= tablet) return DeviceClass.tablet;
    return DeviceClass.mobile;
  }
}

extension BuildContextResponsive on BuildContext {
  double get _width => MediaQuery.sizeOf(this).width;

  DeviceClass get deviceClass => Breakpoints.classify(_width);

  bool get isMobile => deviceClass == DeviceClass.mobile;
  bool get isTablet => deviceClass == DeviceClass.tablet;
  bool get isDesktop => deviceClass == DeviceClass.desktop;

  /// True for tablet or desktop — i.e. "wide enough for a nav rail".
  bool get isWide => deviceClass != DeviceClass.mobile;
}

/// Picks a value by current [DeviceClass], falling back down the scale
/// (desktop -> tablet -> mobile) when a tier isn't specified.
T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  switch (context.deviceClass) {
    case DeviceClass.desktop:
      return desktop ?? tablet ?? mobile;
    case DeviceClass.tablet:
      return tablet ?? mobile;
    case DeviceClass.mobile:
      return mobile;
  }
}
