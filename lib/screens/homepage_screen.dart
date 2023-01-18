import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/models/sidebar_model.dart';
import 'package:test_engine_lms/screens/login_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/dashboard_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/generate_test_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/help_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/notices_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/students_screen.dart';
import 'package:test_engine_lms/screens/side_bar_screens/test_group_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeIndex = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<SideBarModel> sideList = [
    SideBarModel(
      assetsIconPath: "lib/assets/dashboard_icon.png",
      itemName: "DashBoard",
      itemScreen: DashboardScreen(),
    ),
    SideBarModel(
      assetsIconPath: "lib/assets/course_icon.png",
      itemName: "Test Groups Section",
      itemScreen: TestGroupScreen(),
    ),
    SideBarModel(
      assetsIconPath: "lib/assets/exam.png",
      itemName: "Generate Test Section",
      itemScreen: GenerateTestScreen(),
    ),
    SideBarModel(
      assetsIconPath: "lib/assets/student.png",
      itemName: "Students",
      itemScreen: StudentScreen(),
    ),
    SideBarModel(
      assetsIconPath: "lib/assets/notification.png",
      itemName: "Notices",
      itemScreen: NoticeScreen(),
    ),
    SideBarModel(
      assetsIconPath: "lib/assets/help.png",
      itemName: "Help",
      itemScreen: HelpScreen(),
    ),
    SideBarModel(
      itemScreen: Container(),
      itemName: "Logout",
      assetsIconPath: "lib/assets/logout.png",
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(DataController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MediaQuery.of(context).size.width > 800
          ? null
          : AppBar(
              backgroundColor: Constants.primaryColor,
              actions: [
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Institute Name",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://avatars.githubusercontent.com/u/91717890?v=4"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
      drawer: getSideList(),
      body: Row(
        children: [
          /// side bar
          if (MediaQuery.of(context).size.width > 800)
            getSideList()
          else
            const SizedBox(),
          Expanded(child: sideList[activeIndex].itemScreen!),
        ],
      ),
    );
  }

  getSideList() {
    return Container(
      height: Get.height,
      width: 250,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
          color: Constants.primaryColor),
      child: Column(
        children: [
          Expanded(
              child: ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              ///drawer header
              Container(
                height: 170,
                width: 230,
                alignment: Alignment.center,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///user Image
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://avatars.githubusercontent.com/u/91717890?v=4"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    ///institute name
                    Text("Institute Name",
                        style: TextStyle(
                          color: Constants.textColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              const Divider(color: Colors.indigoAccent),
              SizedBox(
                height: Get.height - 170,
                child: ListView.builder(
                  itemCount: sideList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                activeIndex == index
                                    ? Colors.indigoAccent
                                    : Colors.blue,
                                const Color(0xff00B3EE)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: activeIndex == index
                                ? Colors.lightBlueAccent
                                : Colors.indigo,
                            boxShadow: activeIndex == index
                                ? [
                                    const BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 0,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : [],
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              sideList[index].assetsIconPath.toString(),
                              height: 20,
                              width: 20,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (scaffoldKey.currentState?.isDrawerOpen ==
                                  true) {
                                scaffoldKey.currentState?.closeDrawer();
                              }
                              if (index != sideList.length - 1) {
                                setState(() {
                                  activeIndex = index;
                                });
                              } else {
                                Get.defaultDialog(
                                    buttonColor: Colors.indigo,
                                    confirmTextColor: Colors.white,
                                    title: "Alert",
                                    content: const Center(
                                      child: Text(
                                          "Are You sure that you want to logout?"),
                                    ),
                                    onCancel: () {},
                                    cancelTextColor: Colors.indigo,
                                    onConfirm: () async {
                                      await StorageService().deleteAllData();
                                      Get.offAll(() => LoginPage());
                                    });
                              }
                            },
                            title: Text("${sideList[index].itemName}",
                                style: const TextStyle(color: Colors.white)),
                            dense: true,
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
