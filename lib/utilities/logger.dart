import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
      methodCount: 0,  // number of method calls to be displayed
      errorMethodCount: 8,  // number of method calls if an error is logged
      lineLength: 120,  // width of the log print
      colors: true,  // Colorful log messages
      printEmojis: true,  // Print emojis for each log level
      printTime: false  // Should each log print contain a timestamp
  ),
);
