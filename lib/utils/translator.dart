class Translator {
  final Map<dynamic, dynamic> decodedMap;
  final String key, defaultValue;

  Translator(this.decodedMap, this.key, {String defaultValue})
      : this.defaultValue = defaultValue ?? key;

  String translate() {
    final lastSubKey = key.split('.').last;
    final value = _subMap[lastSubKey];
    return value is String ? value : defaultValue;
  }

  Map<dynamic, dynamic> get _subMap {
    final subKeys = key.split('.')..removeLast();
    Map<dynamic, dynamic> subMap = decodedMap ?? {};
    subKeys.forEach((e) => subMap = subMap[e] ?? {});
    return subMap;
  }
}
