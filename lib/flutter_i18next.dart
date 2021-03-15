import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18next/loaders/file_translation_loader.dart';
import 'package:flutter_i18next/loaders/translation_loader.dart';
import 'package:flutter_i18next/utils/interpolation.dart';
import 'package:flutter_i18next/utils/translator.dart';
export 'flutter_i18next_delegate.dart';
export 'loaders/file_translation_loader.dart';
export 'loaders/namespace_file_translation_loader.dart';
export 'loaders/network_file_translation_loader.dart';
export 'loaders/translation_loader.dart';
export 'utils/interpolation.dart';

enum LoadingStatus { notLoaded, loading, loaded }

class FlutterI18Next {
  final Locale _locale;
  final TranslationLoader _translationLoader;
  final InterpolationOptions _interpolationOptions;
  final _loadingStream = StreamController<LoadingStatus>.broadcast();

  Map<dynamic, dynamic> decodedMap;

  Stream<LoadingStatus> get loadingStream => _loadingStream.stream;

  Stream<bool> get isLoadedStream => loadingStream
      .map((loadingStatus) => loadingStatus == LoadingStatus.loaded);

  FlutterI18Next(
    this._locale,
    TranslationLoader translationLoader, {
    InterpolationOptions interpolationOptions,
  })  : this._interpolationOptions =
            interpolationOptions ?? InterpolationOptions(),
        this._translationLoader = translationLoader ?? FileTranslationLoader() {
    this._loadingStream.add(LoadingStatus.notLoaded);
  }

  Future<bool> load() async {
    this._loadingStream.add(LoadingStatus.loading);
    decodedMap = await _translationLoader.load(_locale);
    this._loadingStream.add(LoadingStatus.loaded);
    return true;
  }

  dispose() {
    _loadingStream.close();
  }

  static String t(
    BuildContext context,
    String key, {
    List<String> fallbackKeys,
    String defaultValue,
    Map<String, dynamic> params,
    int count,
  }) {
    final FlutterI18Next currentInstance = _retrieveCurrentInstance(context);
    final translator = Translator(
      currentInstance.decodedMap,
      key,
      fallbackKeys: fallbackKeys,
      defaultValue: defaultValue,
      interpolation: currentInstance._interpolationOptions,
      params: params,
      count: count,
    );
    return translator.translate();
  }

  static FlutterI18Next _retrieveCurrentInstance(BuildContext context) {
    return Localizations.of<FlutterI18Next>(context, FlutterI18Next);
  }

  /// Used to retrieve the loading status stream
  static Stream<LoadingStatus> retrieveLoadingStream(
      final BuildContext context) {
    return _retrieveCurrentInstance(context).loadingStream;
  }

  /// Used to check if the translation file is still loading
  static Stream<bool> retrieveLoadedStream(final BuildContext context) {
    return _retrieveCurrentInstance(context).isLoadedStream;
  }
}
