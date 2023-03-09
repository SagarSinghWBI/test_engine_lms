import 'dart:convert';

import 'package:flutter/material.dart';

int instituteId = 0;

class Constants {
  ///app constants
  static String appName = "TestMaker || AdminPanel";
  static Color primaryColor = Colors.indigoAccent.shade200;
  static Color secondaryColor = Colors.blue;
  static Color tableBackgroundColor1 = Colors.orange.shade100;
  static Color tableBackgroundColor2 = Colors.orange.shade100;
  static Color headerColor = Colors.white;
  static Color dataColor = Colors.white;
  static Color textColor = Colors.white;

  final String _username = "";
  final String _password = "";

  getBasicAuth() =>
      'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';

  ///links to another website
  static String buySubscriptionURL = "https://testmakeronline.com";
  static String helpAndSupportUrl = "https://testmakeronline.com/support/";
  static String bulkStudentFormatUrl =
      "https://docs.google.com/spreadsheets/d/1XCHi27BGPC1E9ZctjvNIMPm1ZNlk0qn9/edit?usp=share_link&ouid=104989674883847852274&rtpof=true&sd=true";
  static String bulkStudentUploadDemo = "https://youtu.be/TNTXetB7G7c";
  static String bulkQuestionsFormatUrl =
      "https://docs.google.com/spreadsheets/d/1xOtuqj2z96Lv1KU1F7ba1YNMCUkjYJ4v/edit?usp=share_link&ouid=104989674883847852274&rtpof=true&sd=true";
  static String bulkQuestionsUploadDemo = "https://youtu.be/UQzgXqBfGj4";

  ///support constants
  static String supportEmail = "sagar.webbullindia@gmail.com";

  ///server constants
  static String liveUrl = "https://assignment.webbulldesign.com";
  static String baseUrl = "https://assignment.webbulldesign.com";
  static String tempUrl = "https://assignment.webbulldesign.com";
}
