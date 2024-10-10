import 'package:logger/logger.dart';

const createLogger = createLoggerInstance;

Logger createLoggerInstance(Type type) {
  return Logger(printer: CustomLogPrinter(type.toString()));
}

class CustomLogPrinter extends PrettyPrinter {
  final String className;

  CustomLogPrinter(this.className);

  static const Map<Level, String> levelColor = {
    // Level.verbose: '\x1B[37m', // White
    Level.debug: '\x1B[34m', // Blue
    Level.info: '\x1B[32m', // Green
    Level.warning: '\x1B[33m', // Yellow
    Level.error: '\x1B[31m', // Red
    // Level.wtf: '\x1B[35m', // Magenta
  };

  @override
  List<String> log(LogEvent event) {
    final color = levelColor[event.level] ?? '\x1B[37m'; // Default to white
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return ['$color$emoji :: $className :: $message\x1B[0m'];
  }
}
