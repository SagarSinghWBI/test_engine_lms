import 'dart:convert';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/screens/homepage_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class AuthController {
  ///reset institute password
  resetInstitutePassword(
      {required void Function() onSuccess,
      required String email,
      required String newPassword}) async {
    getLoadingDialogue(title: "Resetting password..");
    var data = json.encode({"email": email, "password": newPassword});
    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/resetInstitutePassword", data: data)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while resetting password:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///send otp on user email
  sendEmailOTP(
      {required void Function() onSuccess, required String email}) async {
    getLoadingDialogue(title: "Sending OTP");
    try {
      var data = json.encode({"email": email});
      await dio_package.Dio()
          .post("${Constants.baseUrl}/forgetOtp", data: data)
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while sending OTP on email:$e");
      }
      getErrorDialogue(
          errorMessage:
              "Email is not exist in Database. Please Sign up to continue.\n\n$e");
    }
  }

  ///verify otp
  verifyOTP(
      {required String email,
      required String OTP,
      required void Function() onSuccess}) async {
    var data = json.encode({"email": email, "otp": OTP});
    try {
      await dio_package.Dio()
          .post("${Constants.baseUrl}/verifyOtp", data: data)
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 202) {
          ///otp verified then reset password
          onSuccess.call();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while verifying OTP:$e");
      }
    }
  }

  ///get institute dashboard data
  Future<bool> getInstituteDashboardData() async {
    try {
      var id = await StorageService().getData(key: "userId");
      await dio_package.Dio()
          .get("${Constants.baseUrl}/instituteDashboard/$id")
          .then((value) async {
        if (value.statusCode == 200) {
          if (kDebugMode) {
            print("Dashboard data:${value.data}");
          }
          await StorageService().addData(
              key: "totalGroups", value: value.data["totalGroups"].toString());
          await StorageService().addData(
              key: "totalTests", value: value.data["totalTests"].toString());
          await StorageService().addData(
              key: "totalStudents",
              value: value.data["totalStudents"].toString());
          await StorageService().addData(
              key: "totalNotice", value: value.data["totalNotice"].toString());
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting institute dashboard data:$e");
      }
      return false;
    }
    return true;
  }

  ///get subscription by id
  getSubscriptionById({required String subscriptionId}) async {
    try {
      await dio_package.Dio()
          .get("${Constants.baseUrl}/getSubscriptionById/$subscriptionId")
          .then((value) async {
        if (value.statusCode == 200) {
          if (kDebugMode) {
            print("Subscription Data:${value.data}");
          }

          ///subscription details
          await StorageService().addData(
              key: "testLimit", value: value.data["testLimit"].toString());
          await StorageService().addData(
              key: "questionLimit",
              value: value.data["questionLimit"].toString());
          await StorageService().addData(
              key: "userLimit", value: value.data["userLimit"].toString());
          await StorageService().addData(
              key: "inrPrice", value: value.data["inrPrice"].toString());
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting subscription:$e");
      }
    }
  }

  ///login the user
  loginUser({required String email, required String password}) async {
    getLoadingDialogue(title: "Try to login...");
    var data = json.encode({
      "email": email,
      "password": password,
    });
    try {
      dio_package.Dio()
          .post("${Constants.baseUrl}/loginInstitute", data: data)
          .then((value) async {
        removeDialogue();
        if (value.statusCode == 200) {
          getLoadingDialogue(title: "Loading...");

          if (kDebugMode) {
            print("Login Data: ${value.data}");
          }
          await StorageService().addData(
              key: "userId", value: value.data["instituteId"].toString());
          await StorageService().addData(
              key: "userName", value: value.data["userName"].toString());
          await StorageService()
              .addData(key: "userEmail", value: value.data["email"].toString());
          await StorageService().addData(
              key: "userImage", value: value.data["imagePath"].toString());
          await StorageService().addData(
              key: "userPhone", value: value.data["mobile"].toString());
          await getSubscriptionById(
              subscriptionId: value.data["subscription"].toString());
          removeDialogue();

          Get.offAll(() => HomePage(
                instituteId: value.data["instituteId"].toString(),
                userPhone: value.data["mobile"].toString(),
                userEmail: value.data["email"].toString(),
                userImage: value.data["imagePath"].toString(),
                userName: value.data["userName"].toString(),
              ));
        }
      }).onError((error, stackTrace) {
        removeDialogue();
        getErrorDialogue(
            errorMessage:
                "Incorrect Username or Password.\nPlease Try Again.\n\n$error");
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while login user:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///get institute user using their institute id
  getUserById() async {
    getLoadingDialogue(title: "getting User..");
    try {
      var currentInstituteId = await StorageService().getData(key: "userId");
      await dio_package.Dio()
          .get("${Constants.baseUrl}/getInstituteById/$currentInstituteId")
          .then((value) async {
        removeDialogue();
        if (value.statusCode == 200) {
          getLoadingDialogue(title: "Loading...");
          if (kDebugMode) {
            print(value.data);
          }
          await StorageService().addData(
              key: "userId", value: value.data["instituteId"].toString());
          await StorageService().addData(
              key: "userName", value: value.data["userName"].toString());
          await StorageService()
              .addData(key: "userEmail", value: value.data["email"].toString());
          await StorageService().addData(
              key: "userImage", value: value.data["imagePath"].toString());
          await StorageService().addData(
              key: "userPhone", value: value.data["mobile"].toString());
          await getSubscriptionById(
              subscriptionId: value.data["subscription"].toString());

          removeDialogue();
          Get.offAll(() => HomePage(
                instituteId: value.data["instituteId"].toString(),
                userPhone: value.data["mobile"].toString(),
                userEmail: value.data["email"].toString(),
                userImage: value.data["imagePath"].toString(),
                userName: value.data["userName"].toString(),
              ));
          // await StorageService().addData(key: "key", value: value);
          ///
          // Get.offAll(() => HomePage(
          //     userEmail: userEmail,
          //     userImage: userImage,
          //     userName: userName,
          //     userPhone: userPhone));
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while getting user:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  ///update institute by id
  updateInstitute(
      {required String userName,
      required String mobile,
      required FilePickerResult? instituteImage,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "updating institute profile...");

    try {
      var data = json.encode({
        "userName": userName,
        "password": "password",
        "mobile": mobile,
        "email": "webbullindia@gmail.com",
        "registrationDate": "2019-12-31",
        "userStudents": null,
        "groups": null,
        "notifications": null
      });
      dio_package.MultipartFile? imagefile;
      if (instituteImage != null) {
        imagefile = dio_package.MultipartFile.fromBytes(
          instituteImage.files.first.bytes!,
          filename: instituteImage.files.first.name,
        );
      }
      var id = await StorageService().getData(key: "userId");
      int currentInstituteId = int.parse(id.toString());
      var header = await StorageService().getHeaders();

      dio_package.FormData formData =
          dio_package.FormData.fromMap({"data": data, "imagefile": imagefile});

      await dio_package.Dio()
          .put(
              "${Constants.baseUrl}/updateInstituteById/${instituteId != 0 ? instituteId : currentInstituteId}",
              data: formData,
              options: dio_package.Options(headers: header))
          .then((value) {
        print("WE are here>>>>>>>>>>>>${value.data}");
        removeDialogue();
        if (value.statusCode == 200) {
          ///success
          onSuccess.call();
          // getSuccessDialogue(
          //     message: "Institute Profile Updated Successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating institute:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }

  assignMultipleCoursesToStudents(
      {required List<int> studentIds,
      required List<int> courseIds,
      required void Function() onSuccess}) async {
    getLoadingDialogue(title: "Assigning groups please wait...");
    var data =
        json.encode({"studentIds": studentIds, "groupCourseIds": courseIds});

    var header = await StorageService().getHeaders();

    print("Sending data is:$data");
    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/assignMultipleStudentsAndMultipleCourses",
              data: data, options: dio_package.Options(headers: header))
          .then((value) {
        removeDialogue();
        if (value.statusCode == 200) {
          onSuccess.call();
          getSuccessDialogue(message: "Groups assigned successfully.");
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while assigning courses to students:$e");
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
