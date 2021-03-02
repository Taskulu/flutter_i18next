import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_i18next/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CustomNetworkFileTranslationLoader extends NetworkFileTranslationLoader {
  CustomNetworkFileTranslationLoader({baseUri})
      : super(baseUri: baseUri, decodeStrategies: [JsonDecodeStrategy()]);

  Future<String> loadString(final String fileName, final String extension) {
    return networkAssetBundle.loadString("");
  }
}

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: CustomNetworkFileTranslationLoader(
      baseUri: Uri.https("postman-echo.com", "get",
          {"title": "Basic network example", "content": "Translated content"}),
    ),
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
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.t(context, "args.title"))),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<bool>(
                stream: FlutterI18n.retrieveLoadedStream(context),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Text("isLoading: ${snapshot.data}");
                },
              ),
              Text(
                FlutterI18n.t(context, "args.content"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
