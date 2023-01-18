import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test_engine_lms/models/GetNotificationModel.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class DataController extends GetxController {
  ///add group
  addGroup(
      {required String groupName, required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Adding Group Course...");

    var id = await StorageService().getData(key: "userId");
    int currentInstituteId = int.parse(id.toString());
    var data = json.encode({
      "groupName": groupName,
      "multipleTests": [],
      "institute": {
        "instituteId": instituteId != 0 ? instituteId : currentInstituteId
      }
    });

    try {
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addGroup", data: data)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
          getSuccessDialogue(message: "Group Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while adding group:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get all groups
  Future<List<GroupModel>> getAllGroups() async {
    List<GroupModel> modelList = [];
    var id = await StorageService().getData(key: "userId");
    int currentInstituteId = int.parse(id.toString());
    try {
      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllCourseByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}")
          .then((value) {
        print(value.data);
        value.data.reversed.forEach((element) {
          modelList.add(GroupModel.fromJson(element));
        });
      });
    } catch (e) {
      print("Error while getting groups:$e");
    }
    return modelList;
  }

  ///update group
  updateGroup(
      {required GroupModel model,
      required String newGroupName,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Updating Group...");

    var data = json.encode({"groupName": newGroupName, "multipleTests": []});

    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/updateGroupById/${model.groupId}",
              data: data)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
          getSuccessDialogue(message: "Group Updated Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating user:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///add student
  addStudent({
    required String studentName,
    required String password,
    required String mobile,
    required String email,
    required FilePickerResult? studentImage,
    required void Function() onSuccess,
  }) async {
    getLoadingDialogue(title: "Adding Student...");

    dio_package.MultipartFile? studentFile;
    if (studentImage != null) {
      Uint8List? fileBytes = studentImage.files.single.bytes;
      String filename = studentImage.files.single.name;
      studentFile = dio_package.MultipartFile.fromBytes(
        fileBytes!,
        filename: filename,
        contentType:
            MediaType('image', '${studentImage.files.single.extension}'),
      );
    }

    var id = await StorageService().getData(key: "userId");

    String aStr = id.toString().replaceAll(RegExp(r'[^0-9]'), ''); // '23'

    int currentInstituteId = int.parse(aStr == "" ? "0" : aStr);

    var data = json.encode({
      "userName": studentName,
      "password": password,
      "mobile": mobile,
      "email": email,
      "institute": {
        "instituteId": instituteId != 0 ? instituteId : currentInstituteId
      },
      "registrationDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "optcoursesIds": []
    });

    dio_package.FormData formData =
        dio_package.FormData.fromMap({"data": data, "imagefile": studentFile});

    try {
      await dio_package.Dio()
          .post("${Constants.baseUrl}/addStudent", data: formData)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          ///student added
          onSuccess.call();
          getSuccessDialogue(message: "Student Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while adding student:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get all students
  Future<List<GetStudentsModel>> getAllStudents() async {
    List<GetStudentsModel> modelList = [];
    try {
      await dio_package.Dio()
          .get("${Constants.baseUrl}/getAllStudentByInstituteId/1")
          .then((value) {
        if (value.statusCode == 200) {
          value.data.reversed.forEach((element) {
            modelList.add(GetStudentsModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      print("Error while getting students:$e");
    }
    return modelList;
  }

  ///update student
  updateStudent(
      {required String userName,
      required String email,
      required String mobile}) {
    var data = json.encode({
      {
        "userName": "vibha",
        "password": "vibha",
        "mobile": "9090909090",
        "email": "vibha@gmail.com",
        "registrationDate": "2022-08-01",
        "optcoursesIds": [1, 2, 3, 4]
      }
    });
  }

  ///
  /// add notice
  addNotice(
      {required String content, required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Adding Notice...");
    try {
      var id = await StorageService().getData(key: "userId");

      int currentInstituteId = int.parse(id);

      int iId = instituteId != 0 ? instituteId : currentInstituteId;

      var data = json.encode({
        "noticeDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "noticeTime": DateFormat("HH:MM:SS").format(DateTime.now()),
        "content": content,
        "institute": {"instituteId": iId}
      });

      if (kDebugMode) {
        print("Sending data is:$data");
      }

      await dio_package.Dio()
          .post("${Constants.baseUrl}/addNotice", data: data)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
          getSuccessDialogue(message: "Notice Added Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while adding a notice:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get all notifications
  Future<List<GetNotificationModel>> getAllNotifications() async {
    List<GetNotificationModel> modelList = [];
    try {
      var id = await StorageService().getData(key: "userId");
      int currentInstituteId = int.parse(id);

      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllNoticeByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}")
          .then((value) {
        if (value.statusCode == 200) {
          value.data.forEach((element) {
            modelList.add(GetNotificationModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting notifications:$e");
      }
    }
    return modelList;
  }
}
