import 'dart:convert';
import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/screens/homepage_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class AuthController {
  loginUser({required String username, required String password}) async {
    getLoadingDialogue(title: "Try to login...");
    var data = json.encode({
      "username": username,
      "password": password,
    });
    try {
      dio_package.Dio()
          .post("${Constants.tempUrl}/authenticate", data: data)
          .then((value) async {
        removeDialogue();
        if (value.statusCode == 200) {
          if (kDebugMode) {
            print("Login Data: ${value.data}");
          }
          await StorageService()
              .addData(key: "userId", value: value.data["userId"].toString());
          await StorageService()
              .addData(key: "token", value: value.data["jwt"].toString());
          Get.offAll(() => HomePage());
        }
      }).onError((error, stackTrace) {
        removeDialogue();
        getErrorDialogue(errorMessage: "Incorrect Username or Password.\nPlease Try Again.\n\n$error");
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while login user:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get all students
  // Future<List<GetStudentsModel>> getAllStudents() async {
  //   List<GetStudentsModel> modelList = [];
  //   try {
  //     var headers = await StorageService().getHeaders();
  //     await dio_package.Dio()
  //         .get("${Constants.tempUrl}/getAllStudents",
  //             options: dio_package.Options(headers: headers))
  //         .then((value) {
  //       if (value.statusCode == 200) {
  //         modelList.clear();
  //         value.data["students"].forEach((element) {
  //           modelList.add(GetStudentsModel(
  //             userName: element["studentName"].toString(),
  //             description: element["description"].toString(),
  //             email: element["email"].toString(),
  //             mobile: element["mobile"].toString(),
  //             state: element["state"].toString(),
  //             country: element["country"].toString(),
  //             studentId: int.parse(element["studentId"].toString()),
  //             courses: element["courses"] as List<dynamic>?,
  //             optCoursesNames: element["optCoursesNames"] as List<dynamic>?,
  //           ));
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error while getting students:$e");
  //     }
  //   }
  //   return modelList;
  // }
}
