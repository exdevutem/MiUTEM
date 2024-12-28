import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileController{

  // Get the directory for storing application documents
  Future<Directory> getApplicationDocumentsDirectoryPath() async {
    return await getApplicationDocumentsDirectory();
  }

  // Save a file to the application documents directory
  Future<String> saveFile(String fileName, List<int> fileBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsBytes(fileBytes);
    return path;
  }

  // Open a file from the application documents directory
  Future<void> openFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      // Implement the logic to open the file using a suitable package
      // For example, you can use the `open_file` package to open the file
      // await OpenFile.open(filePath);
    } else {
      throw Exception('File not found');
    }
  }

}