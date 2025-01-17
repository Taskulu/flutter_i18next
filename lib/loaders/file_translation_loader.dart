import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_i18next/loaders/decoders/base_decode_strategy.dart';
import 'package:flutter_i18next/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18next/loaders/decoders/xml_decode_strategy.dart';
import 'package:flutter_i18next/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_i18next/loaders/file_content.dart';
import 'package:flutter_i18next/loaders/translation_loader.dart';

/// Loads translation files from JSON, YAML or XML format
class FileTranslationLoader extends TranslationLoader implements IFileContent {
  final String basePath;
  final bool useCountryCode;
  final AssetBundle assetBundle = rootBundle;

  final List<BaseDecodeStrategy> _decodeStrategies;

  FileTranslationLoader(
      {this.basePath = "assets/i18next",
      this.useCountryCode = false,
      decodeStrategies})
      : this._decodeStrategies = decodeStrategies ??
            [JsonDecodeStrategy(), YamlDecodeStrategy(), XmlDecodeStrategy()];

  /// Return the translation Map
  Future<Map?> load(Locale locale) {
    return loadFile(composeFileName(locale));
  }

  /// Load the file using the AssetBundle rootBundle
  @override
  Future<String> loadString(final String fileName, final String extension) {
    return assetBundle.loadString('$basePath/$fileName.$extension',
        cache: false);
  }

  /// Load the fileName using one of the strategies provided
  @protected
  Future<Map?> loadFile(final String fileName) async {
    final List<Future<Map?>> strategiesFutures = _executeStrategies(fileName);
    final Stream<Map?> strategiesStream = Stream.fromFutures(strategiesFutures);
    return strategiesStream.firstWhere((map) => map != null, orElse: () => {});
  }

  List<Future<Map?>> _executeStrategies(final String fileName) {
    return _decodeStrategies
        .map((decodeStrategy) => decodeStrategy.decode(fileName, this))
        .toList();
  }

  /// Compose the file name using the format languageCode_countryCode
  @protected
  String composeFileName(Locale locale) {
    return "${locale.languageCode}${composeCountryCode(locale)}";
  }

  /// Return the country code to attach to the file name, if required
  @protected
  String composeCountryCode(Locale locale) {
    String countryCode = "";
    if (useCountryCode && locale.countryCode != null) {
      countryCode = "_${locale.countryCode}";
    }
    return countryCode;
  }
}
