import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class ImageProcessingService {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    return pickedFiles.map((file) => File(file.path)).toList();
  }

  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<DateTime?> extractTimestamp(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final data = await readExifFromBytes(bytes);

      if (data.isEmpty) {
        return _extractFromFileName(imageFile.path);
      }

      final dateTimeOriginal = data['EXIF DateTimeOriginal'];
      if (dateTimeOriginal != null) {
        return _parseExifDateTime(dateTimeOriginal.toString());
      }

      final dateTime = data['Image DateTime'];
      if (dateTime != null) {
        return _parseExifDateTime(dateTime.toString());
      }

      return _extractFromFileName(imageFile.path);
    } catch (e) {
      print('Failed to extract EXIF timestamp: $e');
      return _extractFromFileName(imageFile.path);
    }
  }

  DateTime? _extractFromFileName(String filePath) {
    final fileName = path.basenameWithoutExtension(filePath);

    final patterns = [
      RegExp(r'(\d{4})[-_](\d{2})[-_](\d{2})[-_](\d{2})[-_](\d{2})[-_](\d{2})'),
      RegExp(r'(\d{4})(\d{2})(\d{2})[-_](\d{2})(\d{2})(\d{2})'),
      RegExp(r'Screenshot_(\d{4})-(\d{2})-(\d{2})-(\d{2})-(\d{2})-(\d{2})'),
      RegExp(r'IMG_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(fileName);
      if (match != null) {
        try {
          final year = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          final day = int.parse(match.group(3)!);
          final hour = int.parse(match.group(4)!);
          final minute = int.parse(match.group(5)!);
          final second = int.parse(match.group(6)!);
          return DateTime(year, month, day, hour, minute, second);
        } catch (e) {
          continue;
        }
      }
    }

    return null;
  }

  DateTime? _parseExifDateTime(String dateTimeStr) {
    try {
      final parts = dateTimeStr.split(' ');
      if (parts.length != 2) return null;

      final dateParts = parts[0].split(':');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length != 3) return null;

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final second = int.parse(timeParts[2]);

      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      return null;
    }
  }

  Future<File> createThumbnail(File imageFile, {int maxSize = 300}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      img.Image resized;
      if (image.width > image.height) {
        resized = img.copyResize(image, width: maxSize);
      } else {
        resized = img.copyResize(image, height: maxSize);
      }

      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = path.join(
        tempDir.path,
        'thumb_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(img.encodeJpg(resized, quality: 85));

      return thumbnailFile;
    } catch (e) {
      print('Failed to create thumbnail: $e');
      return imageFile;
    }
  }

  Future<File> compressImage(File imageFile, {int quality = 85, int maxWidth = 1920}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      img.Image resized = image;
      if (image.width > maxWidth) {
        resized = img.copyResize(image, width: maxWidth);
      }

      final tempDir = await getTemporaryDirectory();
      final compressedPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(img.encodeJpg(resized, quality: quality));

      return compressedFile;
    } catch (e) {
      print('Failed to compress image: $e');
      return imageFile;
    }
  }

  Future<String> saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(imagesDir.path, fileName);

      final compressedImage = await compressImage(imageFile);
      await compressedImage.copy(savedPath);

      return savedPath;
    } catch (e) {
      print('Failed to save image: $e');
      return imageFile.path;
    }
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  Future<List<String>> saveImagesToAppDirectory(List<File> imageFiles) async {
    final savedPaths = <String>[];

    for (final imageFile in imageFiles) {
      try {
        final savedPath = await saveImageToAppDirectory(imageFile);
        savedPaths.add(savedPath);
      } catch (e) {
        print('Failed to save image ${imageFile.path}: $e');
      }
    }

    return savedPaths;
  }
}
