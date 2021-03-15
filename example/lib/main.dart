import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      localizationsDelegates: [
        FlutterI18NextDelegate(
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
      appBar: AppBar(title: Text(FlutterI18Next.t(context, "title"))),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(FlutterI18Next.t(context, 'label.main',
                  params: {'user': 'Test'})),
              Text(FlutterI18Next.t(context, "clicked.times", count: clicked)),
              TextButton(
                  onPressed: () async {
                    incrementCounter();
                  },
                  child:
                      Text(FlutterI18Next.t(context, "button.label.clickMe"))),
            ],
          ),
        );
      }),
    );
  }
}
