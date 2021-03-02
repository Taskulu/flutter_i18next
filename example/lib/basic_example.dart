import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_i18next/flutter_i18next_delegate.dart';
import 'package:flutter_i18next/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/i18n',
        forcedLocale: Locale('es')),
    interpolationOptions: InterpolationOptions(formatter: (value, format, locale) {
      if (format == 'uppercase') {
        return value.toString().toUpperCase();
      }
      return value;
    }),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  runApp(MyApp(flutterI18nDelegate));
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  MyApp(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      builder: FlutterI18n.rootAppBuilder(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHomePage> {
  Locale currentLang;
  int clicked = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        currentLang = FlutterI18n.currentLocale(context);
      });
    });
  }

  changeLanguage() async {
    currentLang =
        currentLang.languageCode == 'en' ? Locale('it') : Locale('en');
    await FlutterI18n.refresh(context, currentLang);
    setState(() {});
  }

  incrementCounter() {
    setState(() {
      clicked++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, "title"))),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(FlutterI18n.t(context, 'label.main',
                  params: {'user': 'Test'})),
              Text(FlutterI18n.t(context, "clicked.times", count: clicked)),
              Text(FlutterI18n.plural(context, "clicked.times", clicked)),
              FlatButton(
                  key: Key('incrementCounter'),
                  onPressed: () async {
                    incrementCounter();
                  },
                  child: Text(FlutterI18n.translate(
                      context, "button.label.clickMea",
                      fallbackKey: "button.label.clickMe"))),
              FlatButton(
                  key: Key('changeLanguage'),
                  onPressed: () async {
                    await changeLanguage();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(FlutterI18n.translate(
                          context, "button.toastMessage")),
                    ));
                  },
                  child: Text(
                      FlutterI18n.translate(context, "button.label.language")))
            ],
          ),
        );
      }),
    );
  }
}
