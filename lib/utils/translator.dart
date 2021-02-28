class Translator {
  final Map<dynamic, dynamic> decodedMap;
  final Map<String, String> params;
  final String key, defaultValue;

  Translator(this.decodedMap, this.key,
      {String defaultValue, this.params = const {}})
      : assert(key != null),
        this.defaultValue = defaultValue ?? key;

  String translate() {
    final rawValue = _rawValue;
    return _getInterpolatedValue(rawValue);
  }

  String _getInterpolatedValue(String rawValue) {
    String interpolatedValue = rawValue;
    params.keys
        .forEach((e) => interpolatedValue = interpolatedValue.replaceAll('{{$e}}', params[e]));
    return interpolatedValue;
  }

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
