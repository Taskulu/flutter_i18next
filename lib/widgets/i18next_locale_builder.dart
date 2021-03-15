import 'package:flutter/material.dart';

typedef LocaleBuilder = Function(BuildContext context, Locale? locale);

class I18NextLocaleBuilder extends StatefulWidget {
  final LocaleBuilder builder;
  final Locale? defaultLocale;

  const I18NextLocaleBuilder(
      {Key? key, required this.builder, this.defaultLocale})
      : super(key: key);

  @override
  I18NextLocaleBuilderState createState() =>
      I18NextLocaleBuilderState(defaultLocale);

  static I18NextLocaleBuilderState? of(BuildContext context) =>
      context.findAncestorStateOfType<I18NextLocaleBuilderState>();
}

class I18NextLocaleBuilderState extends State<I18NextLocaleBuilder> {
  Locale? _locale;

  I18NextLocaleBuilderState(Locale? defaultLocale) : _locale = defaultLocale;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _locale);
  }

  set locale(Locale? l) => setState(() => _locale = l);

  Locale? get locale => _locale;
}
