import 'package:flutter/cupertino.dart';
import 'package:flutter_i18next/flutter_i18next.dart';
import 'package:flutter_i18next/utils/translator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class TestFormatter {
  String call(dynamic value, String format, Locale locale);
}

class MockFormatter extends Mock implements TestFormatter {}

void main() {
  group('translate', () {
    final tLocale = Locale('en');

    group('accessing key', () {
      final map = {
        "key": "value of key",
        "look": {"deep": "value of look deep"}
      };

      group('normal key', () {
        test('given a valid key', () {
          expect(Translator(map, 'key', locale: tLocale).translate(),
              'value of key');
        });

        test('given a invalid key', () {
          expect(Translator(map, 'test-key', locale: tLocale).translate(),
              'test-key');
        });
      });

      group('deep key', () {
        test('given a valid deep key', () {
          expect(Translator(map, 'look.deep', locale: tLocale).translate(),
              'value of look deep');
        });

        test('given a key with last segment invalid', () {
          expect(Translator(map, 'look.deep-key', locale: tLocale).translate(),
              'look.deep-key');
        });

        test('given a key with first segment invalid', () {
          expect(Translator(map, 'look-key.deep', locale: tLocale).translate(),
              'look-key.deep');
        });

        test('given a key with extra deep segment', () {
          expect(
              Translator(map, 'look.deep.deeper', locale: tLocale).translate(),
              'look.deep.deeper');
        });
      });
    });

    group('default value and fallback keys', () {
      final map = {
        "key": "value of key",
        "look": {"deep": "value of look deep"}
      };

      test('given an invalid key with default value and without fallback keys',
          () {
        expect(
            Translator(map, 'test-key',
                    locale: tLocale, defaultValue: 'default-value')
                .translate(),
            'default-value');
      });

      test(
          'given an invalid key without default value and with fallback keys ( = [valid key])',
          () {
        expect(
            Translator(map, 'test-key', locale: tLocale, fallbackKeys: ['key'])
                .translate(),
            'value of key');
      });

      test(
          'given an invalid key without default value and with fallback keys ( = [invalid key])',
          () {
        expect(
            Translator(map, 'test-key',
                locale: tLocale,
                fallbackKeys: ['another-test-key']).translate(),
            'test-key');
      });

      test(
          'given an invalid key without default value and with fallback keys ( = [valid key, invalid key])',
          () {
        expect(
            Translator(map, 'test-key',
                locale: tLocale,
                fallbackKeys: ['key', 'another-test-key']).translate(),
            'value of key');
      });

      test(
          'given an invalid key without default value and with fallback keys ( = [invalid key, valid key])',
          () {
        expect(
            Translator(map, 'test-key',
                locale: tLocale,
                fallbackKeys: ['another-test-key', 'key']).translate(),
            'value of key');
      });

      test(
          'given an invalid key with default value and fallback keys ( = [valid key])',
          () {
        expect(
            Translator(map, 'test-key',
                locale: tLocale,
                defaultValue: 'default-value',
                fallbackKeys: ['key']).translate(),
            'value of key');
      });

      test(
          'given an invalid key with default value and fallback keys ( = [invalid key])',
          () {
        expect(
            Translator(map, 'test-key',
                locale: tLocale,
                defaultValue: 'default-value',
                fallbackKeys: ['another-test-key']).translate(),
            'default-value');
      });
    });

    group('with interpolation', () {
      final map = {"key": "{{what}} is {{how}}"};

      test('without passing parameters', () {
        expect(
            Translator(
              map,
              'key',
              locale: tLocale,
            ).translate(),
            '{{what}} is {{how}}');
      });

      test('passing parameters without containing variables', () {
        expect(
            Translator(
              map,
              'key',
              locale: tLocale,
              params: {'test': 'value'},
            ).translate(),
            '{{what}} is {{how}}');
      });

      test('passing parameters containing one of the variables', () {
        expect(
            Translator(
              map,
              'key',
              locale: tLocale,
              params: {'how': 'great'},
            ).translate(),
            '{{what}} is great');
      });

      test('passing parameters containing all of the variables', () {
        expect(
            Translator(
              map,
              'key',
              locale: tLocale,
              params: {'how': 'great', 'what': 'i18next'},
            ).translate(),
            'i18next is great');
      });
    });

    group('formatting', () {
      final map = {
        "key": "The current date is {{date, MM/DD/YYYY}}",
        "key2": "{{text}} just uppercased"
      };

      late InterpolationOptions interpolationOptions;
      late MockFormatter mockFormatter;

      setUp(() {
        registerFallbackValue<Locale>(Locale('en'));
        mockFormatter = MockFormatter();
        interpolationOptions =
            InterpolationOptions(formatter: mockFormatter.call);
      });

      test('variable doesnt have format', () {
        Translator(
          map,
          'key2',
          locale: Locale('en'),
          interpolation: interpolationOptions,
          params: {'text': 'text'},
        ).translate();
        verifyNever(() => mockFormatter.call(any(), any(), any()));
      });

      test('variable has format', () {
        when(() => mockFormatter.call(any(), any(), any())).thenReturn('test');
        final value = DateTime.now();
        final result = Translator(
          map,
          'key',
          locale: Locale('en'),
          interpolation: interpolationOptions,
          params: {'date': value},
        ).translate();
        verify(() => mockFormatter.call(value, 'MM/DD/YYYY', Locale('en')));
        expect(result, 'The current date is test');
      });
    });

    group('singular/plural', () {
      final map = {"key": "an item", "key_plural": "{{count}} items"};

      test('given no count', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
            ).translate(),
            'an item');
      });

      test('given 0 as count', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
              count: 0,
            ).translate(),
            '0 items');
      });

      test('given 1 as count', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
              count: 1,
            ).translate(),
            'an item');
      });

      test('given 2 as count', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
              count: 2,
            ).translate(),
            '2 items');
      });

      test('given 100 as count', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
              count: 100,
            ).translate(),
            '100 items');
      });

      test('given 100 as count with count in variable parameters too', () {
        expect(
            Translator(
              map,
              'key',
              locale: Locale('en'),
              count: 100,
              params: {'count': 200},
            ).translate(),
            '100 items');
      });
    });
  });
}
