import 'dart:io';

class Logger {
  final File _file = File('Logs.txt');
  final Stopwatch _stopwatch = Stopwatch();

  Logger() {
    _stopwatch.start();
    _file.writeAsStringSync(
      '\n********************************\n'
      '\t${DateTime.now()}'
      '\n********************************\n\n',
      mode: FileMode.append,
    );
  }

  void display(int current, int total) {
    double percent = (current / total) * 100;
    String logs = '[$current] Done: ${percent.toStringAsFixed(1)} % '
        '${_stopwatch.elapsedMilliseconds / 1000} ms';
    _file.writeAsStringSync(
      '$logs\n',
      mode: FileMode.append,
    );
    print(logs);
  }

  void displayTotal() {
    _stopwatch.stop();
    String logs = 'Total time: ${_stopwatch.elapsedMilliseconds / 1000} sec';

    _file.writeAsStringSync(
      '\n$logs'
      '\n********************************\n',
      mode: FileMode.append,
    );
    print(logs);
  }
}
