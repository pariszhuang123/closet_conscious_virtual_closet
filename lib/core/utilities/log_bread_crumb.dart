import 'package:sentry_flutter/sentry_flutter.dart';

void logBreadcrumb(
    String message, {
      String category = 'app',
      SentryLevel level = SentryLevel.info,
      Map<String, dynamic>? data,
    }) {
  Sentry.addBreadcrumb(Breadcrumb(
    message: message,
    category: category,
    level: level,
    data: data,
  ));
}
