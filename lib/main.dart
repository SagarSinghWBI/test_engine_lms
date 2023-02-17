import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_engine_lms/screens/homepage_screen.dart';
import 'package:test_engine_lms/screens/login_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      onInit: () async {
        // String token = await StorageService().getData(key: "token");
        // if (token != "null") {
        //   if (kDebugMode) {
        //     print("Token is: $token");
        //   }
        //   await StorageService().checkToken();
        // }
      },
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      color: Colors.indigo,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme()
            .copyWith(bodyLarge: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      // home: HomePage(),
      home: _storage.hasData("userId")
          ? HomePage(
              instituteId: _storage.read("userId"),
              userPhone: _storage.read("userPhone").toString(),
              userName: _storage.read("userName").toString(),
              userImage: _storage.read("userImage").toString(),
              userEmail: _storage.read("userEmail").toString(),
            )
          : const LoginPage(),
    );
  }
}
