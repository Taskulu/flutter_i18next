class Translator {
  final Map<dynamic, dynamic> decodedMap;
  final String key;

  Translator(this.decodedMap, this.key);

  String translate() {
    final lastSubKey = key.split('.').last;
    return _subMap[lastSubKey];
  }

  Map<dynamic, dynamic> get _subMap {
    final subKeys = key.split('.')..removeLast();
    Map<dynamic, dynamic> subMap = decodedMap ?? {};
    subKeys.forEach((e) => subMap = subMap[e] ?? {});
    return subMap;
  }
}
