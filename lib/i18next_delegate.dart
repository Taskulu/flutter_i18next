import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18next/utils/interpolation.dart';
import 'i18next.dart';

class I18NextDelegate extends LocalizationsDelegate<I18Next> {
  final InterpolationOptions? interpolationOptions;
  final TranslationLoader? translationLoader;
  Locale? _currentLocale;
  I18Next? _lastTranslationObject;

  I18NextDelegate({
    this.translationLoader,
    this.interpolationOptions,
  });

  @override
  bool isSupported(final Locale locale) {
    return true;
  }

  @override
  Future<I18Next> load(Locale locale) async {
    _currentLocale = locale;
    _lastTranslationObject?.dispose();
    _lastTranslationObject = I18Next(
      locale,
      translationLoader,
      interpolationOptions: interpolationOptions,
    );
    await _lastTranslationObject!.load();
    return _lastTranslationObject!;
  }

  @override
  bool shouldReload(final I18NextDelegate old) {
    return this._currentLocale == null ||
        this._currentLocale == old._currentLocale;
  }
}
