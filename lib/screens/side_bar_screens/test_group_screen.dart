import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_group_course_screen.dart';
import 'package:test_engine_lms/screens/other_screens/delete_forms/delete_course_screen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_course_group_form.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class TestGroupScreen extends StatefulWidget {
  const TestGroupScreen({Key? key}) : super(key: key);

  @override
  State<TestGroupScreen> createState() => _TestGroupScreenState();
}

class _TestGroupScreenState extends State<TestGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<DataController>(
      initState: (state) {
        if (state.controller!.filteredGroupModelList.isEmpty) {
          state.controller?.getAllGroups();
        }
      },
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Test Group Section:",
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
                MyButton(
                    icon: const Icon(Icons.add, size: 25, color: Colors.white),
                    width: Get.width,
                    text: "Add Group",
                    onTap: () {
                      Get.dialog(const AddGroupCourseScreen());
                    }),
                const SizedBox(height: 15),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          // height: Get.height / 1.6,
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: const Text("Groups",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyanAccent)),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  const MaterialStatePropertyAll(
                                                      Colors.white),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)))),
                                          onPressed: () {
                                            controller.getAllGroups();
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            size: 18,
                                            color: Constants.primaryColor,
                                          ),
                                          label: Text(
                                            "Refresh",
                                            style: TextStyle(
                                                color: Constants.primaryColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      // IconButton(
                                      //     tooltip: "Refresh",
                                      //     onPressed: () {
                                      //       controller.getAllGroups();
                                      //     },
                                      //     icon: const Icon(
                                      //       Icons.refresh,
                                      //       size: 18,
                                      //       color: Colors.white,
                                      //     )),
                                      IconButton(
                                        tooltip: "Edit Course Groups",
                                        onPressed: () {
                                          Get.dialog(EditGroupCourseScreen(
                                            groupCourses:
                                                controller.groupModelList,
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                          tooltip: "Delete Course Groups",
                                          onPressed: () {
                                            Get.dialog(DeleteCourseGroupScreen(
                                              groupList:
                                                  controller.groupModelList,
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
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    getSearchButton(
                                        labelText: "Search for Test Groups",
                                        hintText: "Ex:- ",
                                        onChanged: (String value) {
                                          controller.filteredGroupModelList
                                              .clear();
                                          for (var element
                                              in controller.groupModelList) {
                                            if (element
                                                .toJson()
                                                .toString()
                                                .toLowerCase()
                                                .contains(value
                                                    .trim()
                                                    .toLowerCase())) {
                                              controller.filteredGroupModelList
                                                  .add(element);
                                            }
                                          }
                                        }),
                                    const SizedBox(height: 10),
                                    controller.searchingGroups.value
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
                                                .filteredGroupModelList.isEmpty
                                            ? Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Text(
                                                    "No Data Found !",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: DataTable2(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  headingTextStyle: TextStyle(
                                                    color:
                                                        Constants.headerColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  dataTextStyle: TextStyle(
                                                    color: Constants.dataColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  columns: const [
                                                    DataColumn2(
                                                        label: Text("ID")),
                                                    DataColumn2(
                                                        label: Text("Name")),
                                                    DataColumn2(
                                                        label: Text(
                                                            "Organization ID")),
                                                  ],
                                                  rows: List.generate(
                                                      controller
                                                          .filteredGroupModelList
                                                          .length, (index) {
                                                    return DataRow(cells: [
                                                      DataCell(Text(
                                                        controller
                                                            .filteredGroupModelList[
                                                                index]
                                                            .groupId
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Constants
                                                              .headerColor,
                                                        ),
                                                      )),
                                                      DataCell(Text(controller
                                                          .filteredGroupModelList[
                                                              index]
                                                          .groupName
                                                          .toString())),
                                                      DataCell(Text(controller
                                                          .filteredGroupModelList[
                                                              index]
                                                          .institute
                                                          .toString())),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
