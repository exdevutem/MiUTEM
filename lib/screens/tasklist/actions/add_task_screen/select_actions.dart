
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SelectActions {
  static Future<List<XFile>> pickFiles() async {
    final List<XFile> files = await openFiles(acceptedTypeGroups: [
      const XTypeGroup(
        label: 'images',
        extensions: ['jpg', 'png'],
      ),
      const XTypeGroup(
        label: 'documents',
        extensions: ['pdf', 'docx'],
      ),
    ]);
    if (files.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      logger.i('Application Documents directory: ${directory.path}');
      for (var file in files) {
        final newPath = '${directory.path}/${file.name}';
        await File(file.path).copy(newPath);
        files[files.indexOf(file)] = XFile(newPath);
      }
    }
    return files;
  }

  static Future<void> openDocument(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Handle error if the file could not be opened
      logger.e('Error opening file: ${result.message}');
    }
  }

  static Future<DateTime?> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }
}