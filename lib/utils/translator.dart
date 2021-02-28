import 'package:flutter/cupertino.dart';
import 'package:flutter_i18next/utils/interpolation.dart';

class Translator {
  final Locale locale;
  final InterpolationOptions interpolation;
  final Map<dynamic, dynamic> decodedMap;
  final Map<String, dynamic> params;
  final String key, defaultValue;

  Translator(
    this.decodedMap,
    this.key, {
    String defaultValue,
    this.locale,
    this.interpolation,
    this.params = const {},
  })  : assert(key != null),
        this.defaultValue = defaultValue ?? key;

  String translate() {
    return _interpolatedValue;
  }

  String get _interpolatedValue =>
      _rawValue.splitMapJoin(interpolation.pattern, onMatch: (match) {
        if (match is RegExpMatch) {
          final value = params[match.namedGroup('variable')];
          final format = match.namedGroup('format');

          if (interpolation.formatter == null || format == null) {
            return value;
          }

          return interpolation.formatter(value, format, locale);
        }
        return match.group(0);
      });

  String get _rawValue {
    final lastSubKey = key.split('.').last;
    final rawValue = _subMap[lastSubKey];
    return rawValue is String ? rawValue : defaultValue;
  }

  Map<dynamic, dynamic> get _subMap {
    final subKeys = key.split('.')..removeLast();
    Map<dynamic, dynamic> subMap = decodedMap ?? {};
    subKeys.forEach((e) => subMap = subMap[e] ?? {});
    return subMap;
  }
}
