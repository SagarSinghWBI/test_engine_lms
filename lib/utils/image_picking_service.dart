import 'dart:io';

import 'package:file_picker/file_picker.dart';

class ImagePickingService {
  pickImageFromGallery(
      {required void Function(FilePickerResult file) onSelected}) async {
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"]).then((value) {
      ///image
      if (value != null) {
        onSelected.call(value);
      }
    });
  }

  pickExcelFileFromGallery(
      {required void Function(FilePickerResult file) onSelected}) async {
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"]).then((value) {
      ///image
      if (value != null) {
        onSelected.call(value);
      }
    });
  }

  pickPdfFileFromGallery(
      {required void Function(FilePickerResult file) onSelected}) async {
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"]).then((value) {
      ///image
      if (value != null) {
        onSelected.call(value);
      }
    });
  }

  // pickImageFromCamera({required void Function(File file) onSelected}) async {
  //   await _picker.pickImage(source: ImageSource.camera).then((value) {
  //     if (value != null) {
  //       onSelected.call(File(value.path));
  //     }
  //   });
  // }
}
