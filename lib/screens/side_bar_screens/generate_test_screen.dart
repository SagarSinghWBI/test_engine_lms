import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/edit_questions_controller.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_bulk_questions_screen.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_test_screen.dart';
import 'package:test_engine_lms/screens/other_screens/delete_forms/delete_test_screen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_questions_screen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_test_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateTestScreen extends StatefulWidget {
  const GenerateTestScreen({Key? key}) : super(key: key);

  @override
  State<GenerateTestScreen> createState() => _GenerateTestScreenState();
}

class _GenerateTestScreenState extends State<GenerateTestScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<TestController>(
      initState: (state) {
        if (state.controller!.filteredTestModelList.isEmpty) {
          state.controller?.getAllAvailableTests();
        }
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
                      "Tests Section:",
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
                  children: [
                    Expanded(
                      child: MyButton(
                          icon: const Icon(Icons.add,
                              size: 25, color: Colors.white),
                          text: "Add a Test",
                          onTap: () async {
                            ///check for current month limit
                            int testLimit =
                                await TestController().getInstituteTestData();
                            String tests = await StorageService()
                                .getData(key: "totalTests");
                            int totalTests = int.parse(tests);
                            if (totalTests > testLimit) {
                              getUpgradeSubscriptionDialog();
                            } else {
                              Get.dialog(const AddTestScreen());
                            }
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                          icon: const Icon(Icons.add,
                              size: 25, color: Colors.white),
                          text: "Add Bulk Questions",
                          onTap: () async {
                            var priceInr =
                                await StorageService().getData(key: "inrPrice");
                            double price = double.parse(priceInr.toString());

                            print("price inr is :$priceInr");
                            if (price != 0.0) {
                              Get.dialog(const AddBulkQuestions());
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
                          }),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                // MyButton(width: Get.width, text: "Add Bulk Students", onTap: () {}),
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
                              child: const Text("Available Tests",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent)),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    tooltip: "Refresh",
                                    onPressed: () {
                                      controller.getAllAvailableTests();
                                      // Get.dialog(const DeleteTestScreen());
                                    },
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                  tooltip: "Edit Tests",
                                  onPressed: () {
                                    Get.dialog(EditTestScreen(
                                      testList: controller.testModelList,
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  tooltip: "Edit Questions",
                                  onPressed: () {
                                    Get.dialog(EditQuestionsScreen(
                                      testList: controller.testModelList,
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                    tooltip: "Delete Test",
                                    onPressed: () {
                                      Get.dialog(DeleteTestScreen(
                                        allCoursesGroup:
                                            controller.testModelList,
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        getSearchButton(
                          labelText: "Search for Tests",
                          hintText: "Ex- test 1",
                          onChanged: (value) {
                            controller.filteredTestModelList.clear();
                            for (var element in controller.testModelList) {
                              if (element
                                  .toJson()
                                  .toString()
                                  .trim()
                                  .toLowerCase()
                                  .contains(value.trim().toLowerCase())) {
                                controller.filteredTestModelList.add(element);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: controller.searchingTests.value
                                ? Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Constants.primaryColor,
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: const CircularProgressIndicator())
                                : controller.filteredTestModelList.isEmpty
                                    ? Center(
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: const Text(
                                              "No Data Found !",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                      )
                                    : DataTable2(
                                        decoration: BoxDecoration(
                                          // color: Constants.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
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
                                          DataColumn2(label: Text("Questions")),
                                          DataColumn2(label: Text("Time")),
                                          DataColumn2(
                                              label: Text("Start Date")),
                                        ],
                                        rows: List.generate(
                                            controller.filteredTestModelList
                                                .length, (index) {
                                          return DataRow(cells: [
                                            DataCell(Text(
                                              controller
                                                  .filteredTestModelList[index]
                                                  .testId
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Constants.headerColor),
                                            )),
                                            DataCell(Text(controller
                                                .filteredTestModelList[index]
                                                .testName
                                                .toString())),
                                            DataCell(Text(controller
                                                .filteredTestModelList[index]
                                                .totalQuestions
                                                .toString())),
                                            DataCell(Text(controller
                                                .filteredTestModelList[index]
                                                .totalMarks
                                                .toString())),
                                            DataCell(Text(controller
                                                .filteredTestModelList[index]
                                                .startDate
                                                .toString())),
                                          ]);
                                        }),
                                      )),
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
