import 'package:intl/intl.dart';

class CSVExporter {
  static String generateCSV({
    required List<Map<String, dynamic>> data,
    required List<String> headers,
  }) {
    final csv = StringBuffer();

    // Add headers
    csv.writeln(headers.map((h) => _escapeCsv(h)).join(','));

    // Add rows
    for (final row in data) {
      final values = headers.map((h) => _escapeCsv(row[h]?.toString() ?? ''));
      csv.writeln(values.join(','));
    }

    return csv.toString();
  }

  static String generateFilename() {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd_HHmmss').format(now);
    return 'tasks_export_$dateStr.csv';
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
