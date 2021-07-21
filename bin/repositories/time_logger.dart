import 'package:logger/logger.dart';

class TimeLogger {
  final Stopwatch _stopwatch = Stopwatch();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      printEmojis: false,
      lineLength: 90,
    ),
  );

  TimeLogger({String message}) {
    _stopwatch.start();
    _logger.wtf(
      message ?? '*** TIME LOGGER INITIALIZED ***',
    );
  }

  void displayCurrent(int current, int total, {String message}) {
    final double percent = (current / total) * 100;
    final String logsTime = '[$current:$total] Done: ${percent.toStringAsFixed(1)} % '
        '${_stopwatch.elapsedMilliseconds / 1000} ms';

    if (message != null) {
      _logger.i('$message\n$logsTime');
      return;
    }

    _logger.i(logsTime);
  }

  void displayMessage(String message, {String error}) {
    _logger.d(message, error);
  }

  void displayTotal() {
    _stopwatch.stop();
    final String logs = 'Total time: '
        '${_stopwatch.elapsedMilliseconds / 1000} ms';
    _logger.wtf(logs);
  }
}
