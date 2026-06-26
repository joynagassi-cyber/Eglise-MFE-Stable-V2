import 'package:lumina/core/bootstrap/app_bootstrap.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppBootstrap.initialize', () {
    test('throws when supabase env is missing', () async {
      var supabaseCalls = 0;
      var isarCalls = 0;

      await expectLater(
        AppBootstrap.initialize(
          loggerTag: 'TEST',
          dotenvFileName: 'noop.env',
          debugSupabase: false,
          setupGlobalErrorHandlers: () {},
          initLogger: () async {},
          configureImageCache: () {},
          loadDotEnv: (_) async {},
          readEnv: (_) => null,
          initSupabase: ({
            required String url,
            required String anonKey,
            required bool debug,
          }) async {
            supabaseCalls++;
            return null;
          },
          initIsar: () async {
            isarCalls++;
            return IsarService(null);
          },
          delay: (_) async {},
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Configuration Supabase manquante'),
          ),
        ),
      );

      expect(supabaseCalls, 0);
      expect(isarCalls, 0);
    });

    test('retries critical init and returns container with isar override',
        () async {
      SharedPreferences.setMockInitialValues({});
      var supabaseCalls = 0;
      var isarCalls = 0;
      final delays = <Duration>[];

      final stubIsarService = IsarService(null);

      final result = await AppBootstrap.initialize(
        loggerTag: 'TEST',
        dotenvFileName: 'noop.env',
        debugSupabase: false,
        maxAttempts: 3,
        setupGlobalErrorHandlers: () {},
        initLogger: () async {},
        configureImageCache: () {},
        loadDotEnv: (_) async {},
        readEnv: (key) {
          switch (key) {
            case 'SUPABASE_URL':
              return 'https://example.supabase.co';
            case 'SUPABASE_ANON_KEY':
              return 'anon-key';
            default:
              return null;
          }
        },
        initSupabase: ({
          required String url,
          required String anonKey,
          required bool debug,
        }) async {
          supabaseCalls++;
          if (supabaseCalls == 1) {
            throw Exception('boom');
          }
          return null;
        },
        initIsar: () async {
          isarCalls++;
          return stubIsarService;
        },
        delay: (duration) async {
          delays.add(duration);
        },
      );

      expect(supabaseCalls, 2);
      expect(isarCalls, 2);
      expect(delays, [const Duration(seconds: 2)]);

      expect(result.isarService, same(stubIsarService));
      expect(result.container.read(isarServiceProvider), same(stubIsarService));
      result.container.dispose();
    });

    test(
        'rethrows after maxAttempts and applies backoff delay only between attempts',
        () async {
      SharedPreferences.setMockInitialValues({});
      var supabaseCalls = 0;
      final delays = <Duration>[];

      await expectLater(
        AppBootstrap.initialize(
          loggerTag: 'TEST',
          dotenvFileName: 'noop.env',
          debugSupabase: false,
          maxAttempts: 2,
          setupGlobalErrorHandlers: () {},
          initLogger: () async {},
          configureImageCache: () {},
          loadDotEnv: (_) async {},
          readEnv: (key) {
            if (key == 'SUPABASE_URL') return 'https://example.supabase.co';
            if (key == 'SUPABASE_ANON_KEY') return 'anon-key';
            return null;
          },
          initSupabase: ({
            required String url,
            required String anonKey,
            required bool debug,
          }) async {
            supabaseCalls++;
            throw Exception('fail');
          },
          initIsar: () async => IsarService(null),
          delay: (duration) async {
            delays.add(duration);
          },
        ),
        throwsA(isA<Exception>()),
      );

      expect(supabaseCalls, 2);
      // Only 1 delay: between attempt 1 and 2.
      expect(delays, [const Duration(seconds: 2)]);
    });
  });
}
