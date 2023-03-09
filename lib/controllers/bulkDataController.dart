import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class BulkDataController {
  ///upload student excel file
  uploadBulkStudents(
      {required FilePickerResult filePickerResult,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Uploading Students Data...");
    try {
      dio_package.MultipartFile file = dio_package.MultipartFile.fromBytes(
        filePickerResult.files.first.bytes!,
        contentType:
            MediaType('file', '${filePickerResult.files.single.extension}'),
        filename: filePickerResult.files.first.name,
      );

      String iId = await StorageService().getData(key: "userId");
      int instituteId = int.parse(iId);

      dio_package.FormData formData =
          dio_package.FormData.fromMap({"file": file});
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addBulkStudentByInstituteId/$instituteId",
              data: formData)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          ///success
          onSuccess.call();
          getSuccessDialogue(message: "Students Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while uploading students bulk data:$e");
      }
      getErrorDialogue(errorMessage: "Wrong Format or Users Limit Exceeded.");

      // getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///upload questions excel file
  uploadBulkQuestions(
      {required FilePickerResult filePickerResult,
      required int testId,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Uploading Questions Data...");
    try {
      dio_package.MultipartFile file = dio_package.MultipartFile.fromBytes(
        filePickerResult.files.first.bytes!,
        contentType:
            MediaType('file', '${filePickerResult.files.single.extension}'),
        filename: filePickerResult.files.first.name,
      );

      dio_package.FormData formData =
          dio_package.FormData.fromMap({"file": file});
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addBulkQuestionByTestId/$testId",
              data: formData)
          .then((value) {
        removeDialogue();

        if (value.statusCode == 200) {
          ///success
          onSuccess.call();
          getSuccessDialogue(message: "Questions Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while uploading Questions bulk data:$e");
      }
      getErrorDialogue(
          errorMessage: "Wrong format or Questions length doesn't match.");

      // getErrorDialogue(errorMessage: e.toString());
    }
  }
}
