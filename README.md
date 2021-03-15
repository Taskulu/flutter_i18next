# flutter_i18next
A package to bring [i18next](https://www.i18next.com) support for Flutter! This is heavily based on [flutter_i18n](https://github.com/ilteoood/flutter_i18n) but with lots of modification and simplifications.

## Usage

First, Add `flutter_i18next` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_i18next: ^0.2.0
```

Next, Add an instance of `I18NextDelegate` to your app's `localizationsDelegates`:

```dart
MaterialApp(
  supportedLocales: [
    Locale('en'),
    Locale('fa'),
  ],
  localizationsDelegates: [
    I18NextDelegate(
      translationLoader: FileTranslationLoader(
        useCountryCode: false,
        basePath: 'assets/i18n',
      ),
    ),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ],
)
```

Now you can get the translation using the extension method on `BuildContext` or the `I18Next` class directly:

```dart
I18Next.t(context, 'label.main')
//or
context.t('label.main')
```

## Accessing Key

You can pass a normal key or a deep key with a default value and a list of fallback keys when retrieving translation:

```dart
I18Next.t(context, 'deep.key', defaultValue: 'value', fallbackKeys: ['key1', 'key2'])
```

Namespaces are not supported yet.

## Interpolation

Only the basic interpolation from i18next is supported:

```dart
I18Next.t(context, 'key', params: {'param': 'value'})
```

## Formatting

You can provide an instance of `InterpolationOptions` to handle formatting.

```dart
I18NextDelegate(
  interpolationOptions:
      InterpolationOptions(formatter: (value, format, locale) {
    if (format == 'uppercase') {
      return value.toString().toUpperCase();
    } else if (value is DateTime) {
      return DateFormat(format).format(value);
    }
    return value;
  }),
)
```

## Plurals

Right now, it's only possible to define singular and plural key:

```dart
I18Next.t('key', count: 2)
```

Interval plurals and Languages with multiple plurals are not supported yet.

## Locale Changing

It's also possible to use the `I18NextLocaleBuilder` widget provided with the plugin to handle locale changes. First you need to wrap your app inside a `I18NextLocaleBuilder`:

```dart
I18NextLocaleBuilder(
  defaultLocale: Locale('en'),
  builder: (context, locale) => MaterialApp(
    locale: locale,
    ...
  ),
)
```

Now to change the locale you can use:

```dart
I18NextLocaleBuilder.of(context).locale = Locale('en');
//or
context.locale = Locale('en');
```

The given locale should be in the `supportedLocales` of your app and your app (`MaterialApp` or `CupertinoApp`) will take care of the rest (loading translations using delegator and changing app direction).