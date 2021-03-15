import 'package:flutter/cupertino.dart';
import 'package:flutter_i18next/utils/interpolation.dart';

class Translator {
  final Locale locale;
  final int count;
  final InterpolationOptions _interpolation;
  final Map<dynamic, dynamic> _map;
  final Map<String, dynamic> _params;
  final List<String> _keys;
  final String _defaultValue;

  Translator(
    Map<dynamic, dynamic> map,
    String key, {
    this.locale,
    this.count,
    InterpolationOptions interpolation,
    List<String> fallbackKeys,
    String defaultValue,
    Map<String, dynamic> params,
  })  : assert(key != null),
        this._map = map ?? {},
        this._keys = [...(fallbackKeys ?? []), key],
        this._defaultValue = defaultValue ?? key,
        this._params = (params ?? {})..putIfAbsent('count', () => count),
        this._interpolation = interpolation ?? InterpolationOptions();

  String translate() {
    String rawValue;
    for (final key in _keys) {
      rawValue = _getRawValue(key);
      if (rawValue != null) {
        break;
      }
    }
    rawValue ??= _defaultValue;
    return _interpolateValue(rawValue);
  }

  String _interpolateValue(String value) =>
      value.splitMapJoin(_interpolation.pattern, onMatch: (match) {
        if (match is RegExpMatch) {
          final value = _params[match.namedGroup('variable')];
          final format = match.namedGroup('format');

          if (_interpolation.formatter == null || format == null) {
            return value.toString();
          }

          return _interpolation.formatter(value, format, locale);
        }
        return match.group(0);
      });

  String _getRawValue(String key) {
    final subMap = _getSubMap(key);
    var lastSubKey = key.split('.').last;
    if (count != null && count != 1) {
      final lastSubKeyPlural = lastSubKey + '_plural';
      if (subMap.containsKey(lastSubKeyPlural)) {
        lastSubKey = lastSubKeyPlural;
      }
    }
    final rawValue = subMap[lastSubKey];
    return rawValue is String ? rawValue : null;
  }

  Map<dynamic, dynamic> _getSubMap(String key) {
    final subKeys = key.split('.')..removeLast();
    Map<dynamic, dynamic> subMap = _map;
    subKeys.forEach((e) => subMap = subMap[e] ?? {});
    return subMap;
  }
}
