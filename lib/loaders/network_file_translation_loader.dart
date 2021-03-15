import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'file_translation_loader.dart';

/// Loads translations from the remote resource
class NetworkFileTranslationLoader extends FileTranslationLoader {
  final AssetBundle networkAssetBundle;

  NetworkFileTranslationLoader(
      {required Uri baseUri, useCountryCode = false, decodeStrategies})
      : networkAssetBundle = NetworkAssetBundle(baseUri),
        super(
            useCountryCode: useCountryCode, decodeStrategies: decodeStrategies);

  /// Load the file using the AssetBundle networkAssetBundle
  @override
  Future<String> loadString(final String fileName, final String extension) {
    return networkAssetBundle.loadString('$fileName.$extension');
  }
}
