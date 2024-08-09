import 'package:logger/logger.dart';

class CustomLogger {
  final String tag;
  final Logger _logger;

  CustomLogger(this.tag) : _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  void d(String message) {
    _logger.d('[$tag] $message');
  }

  void i(String message) {
    _logger.i('[$tag] $message');
  }

  void w(String message) {
    _logger.w('[$tag] $message');
  }

  void e(String message) {
    _logger.e('[$tag] $message');
  }
}
