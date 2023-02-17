import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_bulk_students_screen.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_student_screen.dart';
import 'package:test_engine_lms/screens/other_screens/delete_forms/delete_student_screen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/AssignStudentCourseScreen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_student_form.dart';
import 'package:test_engine_lms/screens/other_screens/view_screens/view_performance_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<DataController>(
      initState: (state) {
        state.controller?.getAllStudents();
      },
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Students Section:",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyButton(
                        icon: const Icon(Icons.add,
                            size: 25, color: Colors.white),
                        text: "Add a Student",
                        onTap: () async {
                          ///check for subscription todo
                          var limit =
                              await StorageService().getData(key: "userLimit");
                          int currentAvailableStudent = 1;
                          int userLimit = int.parse(limit.toString());
                          if (currentAvailableStudent <= userLimit) {
                            Get.dialog(const AddStudentScreen());
                          } else {
                            getUpgradeSubscriptionDialog();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Expanded(
                      child: MyButton(
                          icon: const Icon(Icons.add,
                              size: 25, color: Colors.white),
                          text: "Add Bulk Students",
                          onTap: () async {
                            await AuthController().getInstituteDashboardData();

                            ///check for subscription todo
                            var limit = await StorageService()
                                .getData(key: "userLimit");
                            int userLimit = int.parse(limit.toString());

                            String availableStudents = await StorageService()
                                .getData(key: "totalStudents");
                            int currentAvailableStudent =
                                int.parse(availableStudents);

                            ///check for users limit
                            if (currentAvailableStudent <= userLimit) {
                              var priceInr = await StorageService()
                                  .getData(key: "inrPrice");
                              double price = double.parse(priceInr);

                              if (kDebugMode) {
                                print("price inr is :$priceInr");
                              }
                              if (price != 0.0) {
                                Get.dialog(const AddBulkStudents());
                              } else {
                                Get.snackbar("Error",
                                    "Your Subscription is free.\nThe Bulk Data Uploading Feature is only available in paid Subscriptions.",
                                    backgroundColor: Colors.white,
                                    colorText: Colors.red);
                                Get.defaultDialog(
                                    textConfirm: "Upgrade Subscription",
                                    textCancel: "Cancel",
                                    buttonColor: Constants.primaryColor,
                                    onConfirm: () async {
                                      await launchUrl(Uri.parse(
                                          Constants.buySubscriptionURL));
                                    },
                                    onCancel: () {},
                                    title: "Subscription Error",
                                    titleStyle: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                    confirmTextColor: Colors.white,
                                    cancelTextColor: Colors.indigo,
                                    content: const Center(
                                      child: Text(
                                        "Your Subscription is free.\nThe Bulk Data Uploading Feature\nis only available in\npaid Subscriptions.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.indigo),
                                      ),
                                    ));
                              }
                            } else {
                              getUpgradeSubscriptionDialog();
                            }
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: Get.height / 1.6,
                    // width: Get.width/3,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 10, top: 5),
                              child: const Text("Available Students",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent)),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    tooltip: "Refresh",
                                    onPressed: () {
                                      controller.getAllStudents();
                                    },
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    tooltip: "Assign courses",
                                    onPressed: () async {
                                      if (controller.groupModelList.isEmpty) {
                                        await controller.getAllGroups();
                                      }

                                      Get.dialog(AssignStudentCourseScreen(
                                        groupCoursesList:
                                            controller.groupModelList,
                                        studentsList:
                                            controller.studentModelList,
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.add_card_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    tooltip: "Edit Student Data",
                                    onPressed: () {
                                      Get.dialog(EditStudentScreen(
                                        studentList:
                                            controller.studentModelList,
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    tooltip: "Delete Students",
                                    onPressed: () {
                                      Get.dialog(DeleteStudentScreen(
                                        allStudents:
                                            controller.studentModelList,
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 18,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              getSearchButton(
                                  labelText: "Search Students",
                                  hintText: "Ex:- Sagar, Arjun, etc..",
                                  onChanged: (value) {
                                    controller.filteredStudentModelList.clear();
                                    for (var element
                                        in controller.studentModelList) {
                                      if (element
                                          .toJson()
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              value.trim().toLowerCase())) {
                                        controller.filteredStudentModelList
                                            .add(element);
                                      }
                                    }
                                  }),
                              const SizedBox(height: 10),
                              Expanded(
                                child: controller.searchingStudents.value
                                    ? Container(
                                        width: Get.width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Constants.primaryColor,
                                        ),
                                        child:
                                            const CircularProgressIndicator())
                                    : controller
                                            .filteredStudentModelList.isEmpty
                                        ? Center(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: const Text(
                                                  "No Data Found !",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          )
                                        : DataTable2(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            headingTextStyle: TextStyle(
                                              color: Constants.headerColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            dataTextStyle: TextStyle(
                                                color: Constants.dataColor,
                                                fontWeight: FontWeight.w400),
                                            columns: const [
                                              DataColumn2(label: Text("ID")),
                                              DataColumn2(label: Text("Name")),
                                              DataColumn2(
                                                  label: Text("Phone No.")),
                                              DataColumn2(label: Text("Email")),
                                              DataColumn2(
                                                  label:
                                                      Text("View Performance")),
                                            ],
                                            rows: List.generate(
                                                controller
                                                    .filteredStudentModelList
                                                    .length, (index) {
                                              return DataRow(cells: [
                                                DataCell(Text(
                                                  controller
                                                      .filteredStudentModelList[
                                                          index]
                                                      .studentId
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Constants.headerColor,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .filteredStudentModelList[
                                                        index]
                                                    .userName
                                                    .toString())),
                                                DataCell(Text(controller
                                                    .filteredStudentModelList[
                                                        index]
                                                    .mobile
                                                    .toString())),
                                                DataCell(
                                                  Text(controller
                                                      .filteredStudentModelList[
                                                          index]
                                                      .email
                                                      .toString()),
                                                ),
                                                DataCell(ElevatedButton.icon(
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          ShowPerformanceScreen(
                                                              studentModel:
                                                                  controller
                                                                          .filteredStudentModelList[
                                                                      index]));
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Constants
                                                                  .primaryColor),
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                      ),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.view_in_ar,
                                                      color: Colors.white,
                                                    ),
                                                    label: const Text(
                                                        "View Student Performance"))),
                                              ]);
                                            }),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
