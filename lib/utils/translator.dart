import 'package:flutter/cupertino.dart';
import 'package:flutter_i18next/utils/interpolation.dart';

class Translator {
  final Locale locale;
  final InterpolationOptions interpolation;
  final Map<dynamic, dynamic> decodedMap;
  final Map<String, dynamic> _params;
  final String key, defaultValue;
  final int count;

  Translator(
    this.decodedMap,
    this.key, {
    String defaultValue,
    this.locale,
    this.interpolation,
    this.count,
    Map<String, dynamic> params,
  })  : assert(key != null),
        this.defaultValue = defaultValue ?? key,
        this._params = (params ?? {})..putIfAbsent('count', () => count);

  String translate() {
    return _interpolatedValue;
  }

  String get _interpolatedValue =>
      _rawValue.splitMapJoin(interpolation.pattern, onMatch: (match) {
        if (match is RegExpMatch) {
          final value = _params[match.namedGroup('variable')];
          final format = match.namedGroup('format');

          if (interpolation.formatter == null || format == null) {
            return value.toString();
          }

          return interpolation.formatter(value, format, locale);
        }
        return match.group(0);
      });

  String get _rawValue {
    final subMap = _subMap;
    var lastSubKey = key.split('.').last;
    if (count != null && count != 1) {
      final lastSubKeyPlural = lastSubKey + '_plural';
      if (subMap.containsKey(lastSubKeyPlural)) {
        lastSubKey = lastSubKeyPlural;
      }
    }
    final rawValue = subMap[lastSubKey];
    return rawValue is String ? rawValue : defaultValue;
  }

  Map<dynamic, dynamic> get _subMap {
    final subKeys = key.split('.')..removeLast();
    Map<dynamic, dynamic> subMap = decodedMap ?? {};
    subKeys.forEach((e) => subMap = subMap[e] ?? {});
    return subMap;
  }
}
