import 'dart:ui';

typedef FormatCallback = String Function(
  dynamic value,
  String format,
  Locale locale,
);

class InterpolationOptions {
  final String formatSeparator;
  final FormatCallback? formatter;

  InterpolationOptions({
    this.formatter,
    this.formatSeparator = ',',
  });

  RegExp get pattern => RegExp(
        '{{'
        '(?<variable>.*?)'
        '($formatSeparator\\s*(?<format>.*?)\\s*)?'
        '}}',
      );
}
