import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

getUpgradeSubscriptionDialog() {
  Get.defaultDialog(
    title: "Upgrade Your Subscription",
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.red,
    ),
    content: Center(
      child: Column(
        children: [
          Image.asset(
            "lib/assets/upgrade_subscription.png",
            height: 50,
          ),
          const SizedBox(height: 10),
          const Text(
            "The limit has been exceeded. Please upgrade your subscription to continue.",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
        ],
      ),
    ),
    onConfirm: () {
      launchUrl(Uri.parse(Constants.buySubscriptionURL));
    },
    confirmTextColor: Colors.white,
    textConfirm: "Upgrade Now!",
    buttonColor: Constants.primaryColor,
  );
}

getSuccessDialogue({required String message}) {
  Get.defaultDialog(
    title: "Success",
    titleStyle:
        const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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

getErrorDialogue({required String errorMessage, bool setHeight = false}) {
  Get.defaultDialog(
    title: 'Error',
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    content: Container(
      height: setHeight ? 50 : Get.height / 3,
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      )),
    ),
    barrierDismissible: true,
    onConfirm: () {
      Get.back();
    },
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
  );
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
