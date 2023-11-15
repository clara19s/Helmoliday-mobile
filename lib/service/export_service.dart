import 'dart:io' show File, Platform;

abstract class ExportService {
  Future<void> importICSFile();
}
