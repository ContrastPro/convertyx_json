class Logger {
  final Stopwatch _stopwatch = Stopwatch();

  Logger() {
    _stopwatch.start();
  }

  void display(int current, int total) {
    double percent = (current / total) * 100;
    String logs = '\n[$current] Done: ${percent.toStringAsFixed(1)} % '
        '${_stopwatch.elapsedMilliseconds / 1000} ms\n';
    print(logs);
  }

  void displayTotal() {
    _stopwatch.stop();
    String logs = 'Total time: ${_stopwatch.elapsedMilliseconds / 1000} sec';
    print(logs);
  }
}
