import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_i18next/loaders/file_translation_loader.dart';

/// Loads translations from separate files
class NamespaceFileTranslationLoader extends FileTranslationLoader {
  final String fallbackDir;
  final String basePath;
  final bool useCountryCode;
  final List<String> namespaces;
  AssetBundle assetBundle = rootBundle;

  Map<dynamic, dynamic> _decodedMap = {};

  NamespaceFileTranslationLoader(
      {@required this.namespaces,
      this.fallbackDir = "en",
      this.basePath = "assets/flutter_i18n",
      this.useCountryCode = false,
      decodeStrategies})
      : super(
            basePath: basePath,
            useCountryCode: useCountryCode,
            decodeStrategies: decodeStrategies) {
    assert(namespaces != null);
    assert(namespaces.length > 0);
  }

  /// Return the translation Map for the namespace
  Future<Map> load(Locale locale) async {
    await Future.wait(
        namespaces.map((namespace) => _loadTranslation(locale, namespace)));

    return _decodedMap;
  }

  Future<void> _loadTranslation(Locale locale, String namespace) async {
    _decodedMap[namespace] = {};
    _decodedMap[namespace] =
        await loadFile("${composeFileName(locale)}/$namespace");
  }
}
