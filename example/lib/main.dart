import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18next/i18next.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return I18NextLocaleBuilder(
      defaultLocale: Locale('en'),
      builder: (context, locale) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: locale,
        supportedLocales: [
          Locale('en'),
          Locale('fa'),
        ],
        home: MyHomePage(),
        localizationsDelegates: [
          I18NextDelegate(
            translationLoader: FileTranslationLoader(
              useCountryCode: false,
              basePath: 'assets/i18n',
            ),
            interpolationOptions:
                InterpolationOptions(formatter: (value, format, locale) {
              if (format == 'uppercase') {
                return value.toString().toUpperCase();
              }
              return value;
            }),
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHomePage> {
  int clicked = 0;

  incrementCounter() {
    setState(() {
      clicked++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('I18Next'),
        centerTitle: false,
      ),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(I18Next.t(context, 'label.main', params: {'user': 'Test'})),
              Text(I18Next.t(context, 'clicked.times', count: clicked)),
              TextButton(
                  onPressed: () async {
                    incrementCounter();
                  },
                  child: Text(I18Next.t(context, 'button.label.clickMe'))),
              TextButton(
                  onPressed: () async {
                    final i18next = I18NextLocaleBuilder.of(context);
                    i18next?.locale = i18next.locale == Locale('en')
                        ? Locale('fa')
                        : Locale('en');
                  },
                  child: Text(I18Next.t(context, 'button.label.language'))),
            ],
          ),
        );
      }),
    );
  }
}
