import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18next/utils/interpolation.dart';
import 'flutter_i18next.dart';

class FlutterI18NextDelegate extends LocalizationsDelegate<FlutterI18Next> {
  final InterpolationOptions interpolationOptions;
  final TranslationLoader translationLoader;
  Locale _currentLocale;
  FlutterI18Next _lastTranslationObject;

  FlutterI18NextDelegate({
    this.translationLoader,
    this.interpolationOptions,
  });

  @override
  bool isSupported(final Locale locale) {
    return true;
  }

  @override
  Future<FlutterI18Next> load(Locale locale) async {
    _currentLocale = locale;
    _lastTranslationObject?.dispose();
    _lastTranslationObject = FlutterI18Next(
      locale,
      translationLoader,
      interpolationOptions: interpolationOptions,
    );
    await _lastTranslationObject.load();
    return _lastTranslationObject;
  }

  @override
  bool shouldReload(final FlutterI18NextDelegate old) {
    return this._currentLocale == null ||
        this._currentLocale == old._currentLocale;
  }
}
