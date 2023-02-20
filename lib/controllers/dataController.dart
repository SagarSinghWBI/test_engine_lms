import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test_engine_lms/models/AddQuestionsModel.dart';
import 'package:test_engine_lms/models/GetNotificationModel.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class DataController extends GetxController {
  RxBool searchingGroups = false.obs;
  RxList<GroupModel> groupModelList = <GroupModel>[].obs;
  RxList<GroupModel> filteredGroupModelList = <GroupModel>[].obs;

  RxBool searchingStudents = false.obs;
  RxList<GetStudentsModel> studentModelList = <GetStudentsModel>[].obs;
  RxList<GetStudentsModel> filteredStudentModelList = <GetStudentsModel>[].obs;

  RxBool searchingNotices = false.obs;
  RxList<GetNotificationModel> notificationModelList =
      <GetNotificationModel>[].obs;
  RxList<GetNotificationModel> filteredNotificationModelList =
      <GetNotificationModel>[].obs;

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
  getAllGroups() async {
    searchingGroups.value = true;
    var id = await StorageService().getData(key: "userId");
    int currentInstituteId = int.parse(id.toString());
    try {
      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllCourseByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}",
              options: dio_package.Options(
                  headers: {"ngrok-skip-browser-warning": true}))
          .then((value) {
        searchingGroups.value = false;
        if (kDebugMode) {
          print(value.data);
        }
        if (value.statusCode == 200) {
          groupModelList.clear();
          filteredGroupModelList.clear();
          value.data.reversed.forEach((element) {
            groupModelList.add(GroupModel.fromJson(element));
            filteredGroupModelList.add(GroupModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      searchingGroups.value = false;
      if (kDebugMode) {
        print("Error while getting groups:$e");
      }
    }
  }

  ///update group
  updateGroup({
    required GroupModel model,
    required String newGroupName,
    required void Function() onSuccess,
  }) async {
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
      getErrorDialogue(
          errorMessage:
              "Email ID is already available or unknown error occurred.\n\n $e");
    }
  }

  ///get all students todo
  getAllStudents() async {
    searchingStudents.value = true;
    var id = await StorageService().getData(key: "userId");
    var header = await StorageService().getHeaders();

    int currentInstituteId = int.parse(id);

    try {
      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllStudentByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}",
              options: dio_package.Options(headers: header))
          .then((value) {
        searchingStudents.value = false;
        if (value.statusCode == 200) {
          studentModelList.clear();
          filteredStudentModelList.clear();
          value.data.reversed.forEach((element) {
            studentModelList.add(GetStudentsModel.fromJson(element));
            filteredStudentModelList.add(GetStudentsModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      searchingStudents.value = false;
      if (kDebugMode) {
        print("Error while getting students:$e");
      }
    }
  }

  ///update student
  updateStudent({
    required int studentId,
    required String userName,
    required String mobile,
    required void Function() onSuccess,
    required FilePickerResult? image,
  }) async {
    getLoadingDialogue(title: "Updating Student...");
    var data = json.encode({
      "userName": userName,
      "password": "vibha",
      "mobile": mobile,
      "email": "vibha@gmail.com",
      "registrationDate": "2022-08-01",
      "optcoursesIds": [1, 2, 3, 4]
    });

    print("Sending data is:$data");

    dio_package.MultipartFile? imagefile;
    if (image != null) {
      imagefile = dio_package.MultipartFile.fromBytes(image.files.first.bytes!,
          filename: image.files.first.name);
    }

    dio_package.FormData formData =
        dio_package.FormData.fromMap({"data": data, "imagefile": imagefile});

    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/updateStudentById/$studentId",
              data: formData)
          .then((value) {
        if (value.statusCode == 200) {
          removeDialogue();
          onSuccess.call();
          getSuccessDialogue(message: "Student Update Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating student:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

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
  getAllNotifications() async {
    searchingNotices.value = true;
    try {
      var id = await StorageService().getData(key: "userId");

      int currentInstituteId = int.parse(id);

      await dio_package.Dio()
          .get(
              "${Constants.baseUrl}/getAllNoticeByInstituteId/${instituteId != 0 ? instituteId : currentInstituteId}")
          .then((value) {
        searchingNotices.value = false;
        if (value.statusCode == 200) {
          notificationModelList.clear();
          filteredNotificationModelList.clear();
          value.data.reversed.forEach((element) {
            notificationModelList.add(GetNotificationModel.fromJson(element));
            filteredNotificationModelList
                .add(GetNotificationModel.fromJson(element));
          });
        }
      });
    } catch (e) {
      searchingNotices.value = false;
      if (kDebugMode) {
        print("Error while getting notifications:$e");
      }
    }
  }

  ///update a notice
  updateNotice(
      {required String notificationId,
      required String newContent,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Updating notice...");
    var data = json.encode({"content": newContent});
    var header = await StorageService().getHeaders();
    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/updateNotificationById/$notificationId",
              data: data, options: dio_package.Options(headers: header))
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          ///success
          onSuccess.call();
          getSuccessDialogue(message: "Notification updated successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating notice:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

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
