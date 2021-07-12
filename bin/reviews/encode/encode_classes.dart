import 'package:logger/logger.dart';

class TimeLogger {
  final Stopwatch _stopwatch = Stopwatch();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      printEmojis: false,
    ),
  );

  TimeLogger() {
    _stopwatch.start();
  }

  void displayCurrent(int current, int total, {String message}) {
    double percent = (current / total) * 100;
    String logsTime = '[$current:$total] Done: ${percent.toStringAsFixed(1)} % '
        '${_stopwatch.elapsedMilliseconds / 1000} ms';

    if (message != null) {
      _logger.i('$message\n$logsTime');
      return;
    }

    _logger.i(logsTime);
  }

  void displayTotal() {
    _stopwatch.stop();
    String logs = 'Total time: '
        '${_stopwatch.elapsedMilliseconds / 1000} ms';
    _logger.wtf(logs);
  }
}
