// Stub pour Sentry sur Windows (non supporté)
class SentryFlutter {
  static Future<void> init(
    Function(dynamic) optionsConfiguration, {
    required Function() appRunner,
  }) async {
    await appRunner();
  }
}

class Sentry {
  static Future<void> captureException(dynamic exception,
      {dynamic stackTrace, dynamic hint}) async {}
  static Future<void> addBreadcrumb(dynamic breadcrumb) async {}
  static Future<void> captureMessage(String message, {dynamic level}) async {}
  static void configureScope(Function(dynamic) callback) {}
  static dynamic startTransaction(String name, String operation,
          {Map<String, dynamic>? customSamplingContext, bool? bindToScope}) =>
      _StubTransaction();
  static dynamic getSpan() => null;
}

class _StubTransaction implements ISentrySpan {
  @override
  void finish() {}
}

class Breadcrumb {
  Breadcrumb(
      {String? message,
      String? category,
      dynamic level,
      Map<String, dynamic>? data});
}

class Hint {
  factory Hint.withMap(Map<String, dynamic> map) => Hint();
  Hint();
}

class SentryLevel {
  static const error = SentryLevel._();
  static const warning = SentryLevel._();
  static const info = SentryLevel._();
  const SentryLevel._();
}

abstract class ISentrySpan {
  void finish();
}
