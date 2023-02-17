// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? totalGroups;
  String? totalTests;
  String? totalStudents;
  String? totalNotice;

  getDashboardData() async {
    await AuthController().getInstituteDashboardData().then((element) async {
      totalGroups = await StorageService().getData(key: "totalGroups");
      totalTests = await StorageService().getData(key: "totalTests");
      totalStudents = await StorageService().getData(key: "totalStudents");
      totalNotice = await StorageService().getData(key: "totalNotice");

      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (totalGroups == null) {
      getDashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // final shortcuts = Shortcuts.of(context).shortcuts;
        // final key = LogicalKeySet(LogicalKeyboardKey.escape);
        // shortcuts[key] = WidgetsApp.defaultShortcuts[key];
        // document.documentElement?.requestFullscreen().then((value) {
        //
        // });
      }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Admin Dashboard:",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                SizedBox(
                    height: 15,
                    child: IconButton(
                        tooltip: "Refresh",
                        onPressed: () {
                          getDashboardData();
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Constants.primaryColor,
                        ))),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              height: 5,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage("lib/assets/background2.png"),
                      fit: BoxFit.fill,
                    )),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCard(
                          assetImage: "lib/assets/test_group.jpg",
                          onTap: () {},
                          categoryName: "Total Groups",
                          data: totalGroups ?? "0",
                        ),
                        getCard(
                          assetImage: "lib/assets/tests_dash.jpg",
                          onTap: () {},
                          categoryName: "Total Tests",
                          data: totalTests ?? "0",
                        ),
                        getCard(
                          assetImage: "lib/assets/bulk_student.png",
                          onTap: () {},
                          categoryName: "Total Students",
                          data: totalStudents ?? "0",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCard(
                          onTap: () {},
                          assetImage: "lib/assets/notice_dash.jpg",
                          categoryName: "Total Notices",
                          data: totalNotice ?? "0",
                        ),
                        getCard(
                          assetImage: "lib/assets/test_group.jpg",
                          onTap: () {},
                          categoryName: "Total Tests",
                          data: totalTests ?? "0",
                        ),
                        getCard(
                          assetImage: "lib/assets/test_group.jpg",
                          onTap: () {},
                          categoryName: "Total Students",
                          data: totalStudents ?? "0",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCard(
      {required String categoryName,
      required String data,
      required String assetImage,
      required void Function() onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),

          // width: MediaQuery.of(context).size.width / 4,
          // height: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
              color: Colors.orange.shade100,
              border: Border.all(
                color: Colors.white,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.blueAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: Get.width / 8.1,
                    width: Get.width / 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(assetImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              categoryName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                data,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/teacher.gif"),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
