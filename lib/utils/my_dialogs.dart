import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_engine_lms/utils/constants.dart';

getSuccessDialogue({required String message}) {
  Get.defaultDialog(
    title: "Success",
    titleStyle: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
    buttonColor: Constants.primaryColor,
    confirmTextColor: Colors.white,
    content: Center(
      child: Text(
        message,
        style: TextStyle(color: Constants.primaryColor),
        textAlign: TextAlign.center,
      ),
    ),
    onConfirm: () {
      Get.back();
    },
  );
}

getLoadingDialogue({required String title}) {
  Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () async {
      return false;
    },
    title: title,
    content: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SpinKitSquareCircle(
              color: Constants.primaryColor,
            ),
          ),
          const Text("Loading please wait..."),
        ],
      ),
    ),
  );
}

///
getErrorDialogue({required String errorMessage}) {
  Get.defaultDialog(
      title: 'Error',
      titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      content: Container(
        height: Get.height / 3,
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        )),
      ),
      barrierDismissible: true,
      onConfirm: () {
        Get.back();
      },
      confirmTextColor: Colors.white,
      buttonColor: Colors.red);
}

///remove any dialogue
removeDialogue() {
  if (kDebugMode) {
    print('Dialogue removed<<<<<<<<<<<<<<<<');
  }
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
