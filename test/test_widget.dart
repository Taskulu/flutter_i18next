import 'package:flutter/material.dart';
import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './test_loader.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      translationLoader: TestJsonLoader(
          useCountryCode: false,
          fallbackFile: 'en',
          basePath: 'assets/i18n',
          forcedLocale: Locale('en')),
    );

    return MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: [
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: TestWidgetPage());
  }
}

class TestWidgetPage extends StatefulWidget {
  @override
  createState() => TestWidgetPageState();
}

class TestWidgetPageState extends State<TestWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              children: <Widget>[
                Text(FlutterI18n.t(context, "keySingle")),
                Text(FlutterI18n.plural(context, "keyPlural", 1)),
                Text(FlutterI18n.plural(context, "keyPlural", 2)),
                Text(FlutterI18n.t(context, "object.key1")),
                Text(FlutterI18n.t(context, "object")),
                Text(FlutterI18n.translate(context, "object",
                    fallbackKey: "fileName")),
                RaisedButton(
                  onPressed: () async {
                    var locale = FlutterI18n.currentLocale(context);
                    await FlutterI18n.refresh(context, locale);
                  },
                ),
              ],
            ),
          );
        }));
  }
}
