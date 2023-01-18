import 'dart:convert';

import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:test_engine_lms/models/GetNotificationModel.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupCategoryModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class TestController {
  ///add a test
  addTest({
    required void Function() onSuccess,
    required String testName,
    required int totalQuestions,
    required int totalMarks,
    required int totalTime,
    required int showedQuestion,
    required int groupId,
    required String endDate,
  }) async {
    var data = json.encode({
      "testName": testName,
      "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "endDate": endDate,
      "totalQuestions": totalQuestions,
      "totalMarks": totalMarks,
      "totalTime": totalTime,
      "showedQuestion": showedQuestion,
      "questions": [],
      "groupCourse": {"groupId": groupId}
    });
    try {
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addTest", data: data)
          .then((value) {
        if (value.statusCode == 200) {
          onSuccess.call();
          getSuccessDialogue(message: "Test Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while adding test:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get All tests
  Future<List<GetTestModel>> getAllAvailableTests() async {
    List<GetTestModel> modelList = [];
    try {
      var header = await StorageService().getHeaders();

      var currentInstituteId = await StorageService().getData(key: "userId");

      await dio_package.Dio()
          .get(
              "${Constants.tempUrl}/getAllTestByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}",
              options: dio_package.Options(headers: header))
          .then((value) {
        if (value.statusCode == 200) {
          modelList.clear();
          value.data.forEach((element) {
            modelList.add(GetTestModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting all Tests:$e");
      }
    }
    return modelList;
  }

  ///get all group categories
  // Future<List<GroupCategoryModel>> getAllCategories() async {
  //   List<GroupCategoryModel> modelList = [];
  //   try {
  //     var header = await StorageService().getHeaders();
  //     await dio_package.Dio()
  //         .get("${Constants.tempUrl}/getAllCategories",
  //             options: dio_package.Options(
  //               headers: header,
  //             ))
  //         .then((value) {
  //       if (value.statusCode == 200) {
  //         modelList.clear();
  //         value.data.forEach((element) {
  //           modelList.add(GroupCategoryModel(
  //             institute: int.parse(element["institute"].toString()),
  //             categoryName: element["categoryName"].toString(),
  //             categoryId: int.parse(element["categoryId"].toString()),
  //           ));
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error while getting group categories:$e");
  //     }
  //   }
  //   return modelList;
  // }

  // ///get all groups
  // Future<List<GroupModel>> getAllCourses() async {
  //   List<GroupModel> modelList = [];
  //   try {
  //     await dio_package.Dio()
  //         .get("${Constants.tempUrl}/getAllCoursesList")
  //         .then((value) {
  //       if (value.statusCode == 200) {
  //         modelList.clear();
  //         value.data["allCourses"].forEach((element) {
  //           modelList.add(GroupModel(
  //             courseId: int.parse(element["courseId"].toString()),
  //             courseName: element["courseName"].toString(),
  //             description: element["description"].toString(),
  //             price: double.parse(element["price"].toString()),
  //             category: element["category"].toString(),
  //             imageFile: element["imageFile"].toString(),
  //             imageFileName: element["imageFileName"].toString(),
  //             teacher: element["teacher"].toString(),
  //             startDate: element["startDate"].toString(),
  //             paid: element["paid"],
  //             endDate: element["endDate"].toString(),
  //             discount: int.parse(element["discount"].toString()),
  //           ));
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error while getting all groups:$e");
  //     }
  //   }
  //   return modelList;
  // }

  ///get all notifications
  // Future<List<GetNotificationsModel>> getAllNotifications() async {
  //   List<GetNotificationsModel> modelList = [];
  //   try {
  //     var instituteId = await StorageService().getData(key: "userId");
  //     var headers = await StorageService().getHeaders();
  //
  //
  //     await dio_package.Dio()
  //         .get(
  //             "${Constants.tempUrl}/getAllNotificationByInstituteId/1",
  //             options: dio_package.Options(
  //               headers: headers,
  //             ))
  //         .then((value) {
  //       if (value.statusCode == 200) {
  //         modelList.clear();
  //         value.data.forEach((element) {
  //           modelList.add(GetNotificationsModel(
  //             studentId: int.parse(element["studentId"].toString()),
  //             teacherId: int.parse(element["teacherId"].toString()),
  //             instituteId: int.parse(element["instituteId"].toString()),
  //             notificationTime: element["notificationTime"].toString(),
  //             notificationId: int.parse(element["notificationId"].toString()),
  //             notificationDate: element["notificationDate"].toString(),
  //             notification: element["notification"].toString(),
  //             fkCourseId: int.parse(element["fkCourseId"].toString()),
  //           ));
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error while getting notifications:$e");
  //     }
  //   }
  //   return modelList;
  // }
}
