import 'package:flutter_i18next/loaders/file_content.dart';

/// Base decode strategy to convert a text file to a Map
abstract class BaseDecodeStrategy {
  /// The extension of the file to decode
  String get fileExtension;

  /// The method used to load the text file to a Map
  get decodeFunction;

  /// The method that do the loading
  Future<Map> decode(
      final String fileName, final IFileContent fileContent) async {
    Map returnValue;
    try {
      final String content = await loadFileContent(fileName, fileContent);
      returnValue = decodeContent(content);
    } catch (e) {
    }
    return returnValue;
  }

  /// The method that load the whole file content in memory
  Future<String> loadFileContent(
      final String fileName, final IFileContent fileContent) {
    return fileContent.loadString(fileName, fileExtension);
  }

  /// The method that return the decoded Map
  Map decodeContent(final String content) {
    return decodeFunction(content);
  }
}
