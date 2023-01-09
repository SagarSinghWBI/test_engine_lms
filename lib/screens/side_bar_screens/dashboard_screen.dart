// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                            onTap: () {},
                            categoryName: "Total Group Categories",
                            data: "25"),
                        getCard(
                            onTap: () {},
                            categoryName: "Total Groups",
                            data: "20"),
                        getCard(
                            onTap: () {},
                            categoryName: "Total Available Tests",
                            data: "60"),
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
              // gradient: RadialGradient(colors: [
              //   Colors.white,
              //   Colors.indigo,
              // ]),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: Get.width / 8,
                    width: Get.width / 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constants.primaryColor,
                      image: const DecorationImage(
                        image: AssetImage("lib/assets/categories.jpg"),
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
                                color: Colors.indigo,
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
                                  color: Colors.indigo,
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
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/student.gif"),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
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
