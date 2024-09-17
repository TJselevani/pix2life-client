import 'package:logger/logger.dart';

const createLogger = createLoggerInstance;

Logger createLoggerInstance(Type type) {
  return Logger(printer: CustomLogPrinter(type.toString()));
}

class CustomLogPrinter extends PrettyPrinter {
  final String className;

  CustomLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji :: $className :: $message')];
  }
}
