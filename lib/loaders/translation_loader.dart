import 'package:flutter/widgets.dart';

/// Contains the common loading logic
abstract class TranslationLoader {
  static const String LOCALE_SEPARATOR = "_";

  /// Load method to implement
  Future<Map> load(Locale locale);
}
