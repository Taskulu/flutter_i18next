# flutter_i18next
A package to bring i18next support for Flutter! This is heavily based on [flutter_i18n](https://jsfiddle.net/sm9wgLze) but with lots of modification and simplifications.

---

## Usage

First, Add `flutter_i18next` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_i18next: ^0.1.0
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

:WIP: