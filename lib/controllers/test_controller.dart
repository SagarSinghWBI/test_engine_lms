import 'dart:convert';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:test_engine_lms/models/AddQuestionsModel.dart';
import 'package:test_engine_lms/models/GetNotificationModel.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupCategoryModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class TestController extends GetxController {
  RxBool searchingTests = false.obs;
  RxList<GetTestModel> testModelList = <GetTestModel>[].obs;
  RxList<GetTestModel> filteredTestModelList = <GetTestModel>[].obs;

  ///
  ///add institute test data
  addInstituteTestData() async {
    var id = await StorageService().getData(key: "userId");
    int currentInstituteId = int.parse(id.toString());

    var data = json.encode({
      "testData": 1,
      "institute": {"instituteId": currentInstituteId}
    });
    try {
      await dio_package.Dio()
          .post("${Constants.tempUrl}/addInstituteData", data: data)
          .then((value) {
        if (value.statusCode == 200) {
          ///success
          ///
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(">>>>>>Error while adding institute test data:$e");
      }
    }
  }

  Future<int> getInstituteTestData() async {
    int currentTest = 0;

    DateTime currentDate = DateTime.now();
    DateTime initialDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    String formattedCurrentDate = DateFormat("yyyy-MM-dd").format(currentDate);
    String formattedInitialDate = DateFormat("yyyy-MM-dd").format(initialDate);
    String instituteId = await StorageService().getData(key: "userId");
    try {
      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllInstituteDataBy/$formattedInitialDate/$instituteId/$formattedCurrentDate")
          .then((value) {
        if (value.statusCode == 200) {
          int data = 0;
          value.data.forEach((element) {
            data = data + int.parse(element["testData"].toString());
          });
          currentTest = data;
          print("Current Test Data:$data");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting institute test data:$e");
      }
    }
    return currentTest;
  }

  ///add a test
  addTest({
    required void Function() onSuccess,
    required FilePickerResult? pdfAnswerFile,
    required String testName,
    required int totalQuestions,
    required int totalMarks,
    required int totalTime,
    required int showedQuestion,
    required int groupId,
    required String endDate,
    required List<AddQuestionsModel> questionsList,
  }) async {
    getLoadingDialogue(title: "Adding new test");
    var data = json.encode({
      "testName": testName,
      "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "endDate": endDate,
      "totalQuestions": totalQuestions,
      "totalMarks": totalMarks,
      "totalTime": totalTime,
      "showedQuestion": showedQuestion,
      "questions": questionsList,
      "groupCourse": {"groupId": groupId}
    });

    dio_package.MultipartFile? pdfFile;
    if (pdfAnswerFile != null) {
      pdfFile = dio_package.MultipartFile.fromBytes(
          pdfAnswerFile.files.first.bytes!,
          filename: pdfAnswerFile.files.first.name);
    }

    dio_package.FormData formData =
        dio_package.FormData.fromMap({"data": data, "pdfFile": pdfFile});
    try {
      if (kDebugMode) {
        print("Sending data is:$data");
      }

      var header = await StorageService().getHeaders();
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addTest",
              data: formData, options: dio_package.Options(headers: header))
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
          addInstituteTestData();
          getSuccessDialogue(message: "Test Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print(">>>>>>>>>Error while adding test:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get All tests
  getAllAvailableTests() async {
    searchingTests.value = true;
    try {
      var header = await StorageService().getHeaders();
      var currentInstituteId = await StorageService().getData(key: "userId");
      await dio_package.Dio()
          .get(
              "${Constants.tempUrl}/getAllTestByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}",
              options: dio_package.Options(headers: header))
          .then((value) {
        searchingTests.value = false;
        if (value.statusCode == 200) {
          testModelList.clear();
          filteredTestModelList.clear();
          value.data.reversed.forEach((element) {
            testModelList.add(GetTestModel.fromJson(element));
            filteredTestModelList.add(GetTestModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      searchingTests.value = false;
      if (kDebugMode) {
        print("Error while getting all Tests:$e");
      }
    }
  }

  ///update test information
  updateTestInformation(
      {required String testId,
      required String testName,
      required String startDate,
      required String endDate,
      required int totalQuestions,
      required int totalMarks,
      required int showedQuestion,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Updating Test Information...");
    try {
      var data = json.encode({
        "testName": "Mysql Test",
        "startDate": "2023-01-02",
        "endDate": "2023-01-05",
        "totalQuestions": 25,
        "totalMarks": 50,
        "totalTime": 13,
        "showedQuestion": showedQuestion,
        "questions": []
      });
      await dio_package.Dio()
          .put("${Constants.baseUrl}/updateTestById/$testId", data: data)
          .then((value) {
        if (value.statusCode == 200) {
          removeDialogue();
          onSuccess.call();
          getSuccessDialogue(message: "Test Updated Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating test:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }
}
