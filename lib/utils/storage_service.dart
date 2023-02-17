import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:test_engine_lms/screens/login_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  addData({required String key, required String value}) async {
    await _storage.write(key, value);
  }

  getData({required String key}) async {
    var value = await _storage.read(key);
    return value.toString();
  }

  deleteAllData() async {
    await _storage.erase();
  }

  getHeaders() async {
    // "Authorization": "Bearer ${await getData(key: "token")}",

    // var header = {
    //   "Access-Control-Allow-Origin": "*",
    //   "ngrok-skip-browser-warning": true,
    //   "Access-Control-Allow-Headers":
    //   "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-SecurityToken,locale"
    // };

    var header = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };

    return header;
  }

  checkToken() async {
    try {
      var instituteId = await _storage.read("userId");
      var headers = await getHeaders();

      await dio_package.Dio()
          .get(
              "${Constants.tempUrl}/getAllNotificationByInstituteId/$instituteId",
              options: dio_package.Options(
                headers: headers,
              ))
          .then((value) {
        if (value.statusCode == 200) {
          if (kDebugMode) {
            print(">>>>>>>>>>>>>>>>>>>Token is available<<<<<<<<<<<<<<<");
          }
        } else {
          if (kDebugMode) {
            print("Token Expired: ${value.data.toString()}");
            print("Token Expired>>>>>>>>>>>>>");
          }
          Get.snackbar("Token Expired", "Please Login to continue.",
              colorText: Colors.white);
          Get.offAll(() => LoginPage());
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while checking token:$e");
        print("Token Expired>>>>>>>>>>>>>");
      }
      Get.snackbar("Token Expired", "Please Login to continue.",
          colorText: Colors.white);
      Get.offAll(() => LoginPage());
    }
  }
}
