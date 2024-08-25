import 'package:logger/logger.dart';

const logger = createLogger;

Logger createLogger(Type type) {
  return Logger(printer: CustomPrinter(type.toString()));
}

class CustomPrinter extends PrettyPrinter {
  final String className;

  CustomPrinter(this.className);
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji :: $className :: $message')];
  }
}
