class Progress {
  Stopwatch _stopwatch;

  Progress() {
    _stopwatch = Stopwatch();
    _stopwatch.start();
  }

  void display(int current, int total) {
    double percent = (current / total) * 100;
    print('Done: ${percent.toStringAsFixed(1)} % '
        '${_stopwatch.elapsedMilliseconds / 1000} ms');
  }

  void displayTotal() {
    print('\n--- Import complete: 100% ---\n'
        'Total time: ${_stopwatch.elapsedMilliseconds / 1000} sec');
  }
}
