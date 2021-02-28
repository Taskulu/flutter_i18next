import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_asset_bundle.dart';

void main() {
  test('should load correct map', () async {
    var instance = NetworkFileTranslationLoader(baseUri: Uri());
    instance.networkAssetBundle = TestAssetBundle();

    var result = await instance.load();

    expect(result, isMap);
    expect(result, isEmpty);
  });
}
