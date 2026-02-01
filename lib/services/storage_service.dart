import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sentence.dart';
import 'database_helper.dart';

class StorageService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<String> exportToJson() async {
    final sentences = await _db.getAllSentences();
    final data = {
      'version': '1.0.0',
      'exportTime': DateTime.now().toIso8601String(),
      'sentences': sentences.map((s) => s.toMap()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final file = await _saveExportFile('duorecall_backup.json', jsonString);
    return file.path;
  }

  Future<String> exportToCsv() async {
    final sentences = await _db.getAllSentences();
    final buffer = StringBuffer();

    buffer.writeln('ID,Chinese,English,Scene,Tense,ImportTime,ReviewCount,ErrorCount,IsMastered');

    for (final sentence in sentences) {
      buffer.writeln(
        '${sentence.id},'
        '"${_escapeCsv(sentence.chineseText)}",'
        '"${_escapeCsv(sentence.englishText)}",'
        '${sentence.scene},'
        '${sentence.tense},'
        '${sentence.importTime.toIso8601String()},'
        '${sentence.reviewCount},'
        '${sentence.errorCount},'
        '${sentence.isMastered}',
      );
    }

    final file = await _saveExportFile('duorecall_export.csv', buffer.toString());
    return file.path;
  }

  Future<String> exportDatabase() async {
    final db = await _db.database;
    final dbPath = db.path;

    final appDir = await getApplicationDocumentsDirectory();
    final exportPath = path.join(appDir.path, 'duorecall_database.db');

    await File(dbPath).copy(exportPath);
    return exportPath;
  }

  Future<void> shareExportFile(String filePath) async {
    // ignore: deprecated_member_use
    await SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)]),
    );
  }

  Future<ImportResult> importFromJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, message: '未选择文件');
      }

      final file = File(result.files.first.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      final sentencesData = data['sentences'] as List<dynamic>?;
      if (sentencesData == null) {
        return ImportResult(success: false, message: '文件格式错误：未找到句子数据');
      }

      final sentences = sentencesData
          .map((item) => Sentence.fromMap(item as Map<String, dynamic>))
          .toList();

      int importedCount = 0;
      for (final sentence in sentences) {
        await _db.insertSentence(sentence.copyWith(id: null));
        importedCount++;
      }

      return ImportResult(
        success: true,
        message: '成功导入 $importedCount 张卡片',
        importedCount: importedCount,
      );
    } catch (e) {
      return ImportResult(success: false, message: '导入失败：$e');
    }
  }

  Future<ImportResult> importFromDatabase() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, message: '未选择文件');
      }

      final sourceFile = File(result.files.first.path!);
      final tempDb = await openReadOnlyDatabase(sourceFile.path);

      final maps = await tempDb.query('sentences');
      final sentences = maps.map((map) => Sentence.fromMap(map)).toList();

      int importedCount = 0;
      for (final sentence in sentences) {
        await _db.insertSentence(sentence.copyWith(id: null));
        importedCount++;
      }

      await tempDb.close();

      return ImportResult(
        success: true,
        message: '成功导入 $importedCount 张卡片',
        importedCount: importedCount,
      );
    } catch (e) {
      return ImportResult(success: false, message: '导入失败：$e');
    }
  }

  Future<File> _saveExportFile(String fileName, String content) async {
    final appDir = await getApplicationDocumentsDirectory();
    final exportsDir = Directory(path.join(appDir.path, 'exports'));

    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final filePath = path.join(exportsDir.path, fileName);
    final file = File(filePath);
    await file.writeAsString(content);

    return file;
  }

  String _escapeCsv(String value) {
    return value.replaceAll('"', '""');
  }

  Future<int> getCacheSize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));

      if (!await imagesDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final file in imagesDir.list()) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  Future<String> formatCacheSize() async {
    final bytes = await getCacheSize();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> clearCache() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));

      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }

      final tempDir = await getTemporaryDirectory();
      final tempFiles = await tempDir.list().toList();
      for (final file in tempFiles) {
        if (file is File) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }

  Future<void> clearAllData() async {
    await _db.deleteAllSentences();
    await clearCache();
  }
}

class ImportResult {
  final bool success;
  final String message;
  final int? importedCount;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount,
  });
}
