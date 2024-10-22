import 'package:flutter_i18next/loaders/file_translation_loader.dart';
import 'package:universal_io/io.dart';

class LocalTranslationLoader extends FileTranslationLoader {
  LocalTranslationLoader(
      {basePath = "assets/i18next", useCountryCode = false, decodeStrategies})
      : super(
            basePath: basePath,
            useCountryCode: useCountryCode,
            decodeStrategies: decodeStrategies);

  /// Load the file using the File class
  @override
  Future<String> loadString(final String fileName, final String extension) {
    return File('$basePath/$fileName.$extension').readAsString();
  }
}
