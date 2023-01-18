import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GroupCategoryModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_group_category_screen.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_group_course_screen.dart';
import 'package:test_engine_lms/screens/other_screens/delete_forms/delete_category_form.dart';
import 'package:test_engine_lms/screens/other_screens/delete_forms/delete_course_screen.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_category_form.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/edit_course_group_form.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class TestGroupScreen extends StatefulWidget {
  const TestGroupScreen({Key? key}) : super(key: key);

  @override
  State<TestGroupScreen> createState() => _TestGroupScreenState();
}

class _TestGroupScreenState extends State<TestGroupScreen> {
  var dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
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
            // MyButton(
            //     width: Get.width,
            //     text: "Add Group Category",
            //     onTap: () {
            //       Get.dialog(const AddCategoryScreen());
            //     }),
            // const SizedBox(height: 10),
            MyButton(
                width: Get.width,
                text: "Add Course Group",
                onTap: () {
                  Get.dialog(const AddGroupCourseScreen());
                }),
            const SizedBox(height: 15),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.all(5),
                  //     // height: Get.height / 1.6,
                  //     // width: Get.width/3,
                  //     decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter,
                  //           colors: [Colors.indigoAccent, Colors.blue]),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Container(
                  //               alignment: Alignment.centerLeft,
                  //               margin: const EdgeInsets.only(left: 10, top: 5),
                  //               child: const Text("Group Categories",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.cyanAccent)),
                  //             ),
                  //             Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 IconButton(
                  //                     tooltip: "Edit Group Categories",
                  //                     onPressed: () {
                  //                       Get.dialog(const EditCategoryScreen());
                  //                     },
                  //                     icon: const Icon(
                  //                       Icons.edit,
                  //                       size: 18,
                  //                       color: Colors.white,
                  //                     )),
                  //                 IconButton(
                  //                     tooltip: "Delete Group Categories",
                  //                     onPressed: () {
                  //                       Get.dialog(const DeleteCategoryScreen());
                  //                     },
                  //                     icon: const Icon(
                  //                       Icons.delete,
                  //                       size: 18,
                  //                       color: Colors.white,
                  //                     )),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         Expanded(
                  //           child: FutureBuilder(
                  //             future: TestController().getAllCategories(),
                  //             builder: (context, snapshot) {
                  //               if (snapshot.connectionState ==
                  //                   ConnectionState.waiting) {
                  //                 return const Center(
                  //                     child: CircularProgressIndicator(
                  //                   color: Colors.white,
                  //                 ));
                  //               } else if (snapshot.connectionState ==
                  //                   ConnectionState.done) {
                  //                 List<GroupCategoryModel> data =
                  //                     snapshot.data as List<GroupCategoryModel>;
                  //
                  //                 if (data.isEmpty) {
                  //                   return Center(
                  //                     child: Container(
                  //                         padding: const EdgeInsets.all(5),
                  //                         decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                           color: Colors.white,
                  //                         ),
                  //                         child: const Text(
                  //                           "No Data Found !",
                  //                           style: TextStyle(
                  //                               color: Colors.red,
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 10),
                  //                         )),
                  //                   );
                  //                 } else {
                  //                   return DataTable2(
                  //                     headingTextStyle: const TextStyle(
                  //                         color: Colors.lightGreenAccent,
                  //                         fontWeight: FontWeight.w500),
                  //                     dataTextStyle:
                  //                         const TextStyle(color: Colors.white),
                  //                     columns: const [
                  //                       DataColumn2(label: Text("ID")),
                  //                       DataColumn2(label: Text("Name")),
                  //                     ],
                  //                     rows: List.generate(data.length, (index) {
                  //                       return DataRow(cells: [
                  //                         DataCell(Text(data[index]
                  //                             .categoryId
                  //                             .toString())),
                  //                         DataCell(Text(data[index]
                  //                             .categoryName
                  //                             .toString())),
                  //                       ]);
                  //                     }),
                  //                   );
                  //                 }
                  //               }
                  //               return Container();
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      // height: Get.height / 1.6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.indigoAccent, Colors.blue]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 10, top: 5),
                                child: const Text("Groups",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent)),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      tooltip: "Refresh",
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.refresh,
                                        size: 18,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      tooltip: "Edit Course Groups",
                                      onPressed: () {
                                        Get.dialog(
                                            const EditGroupCourseScreen());
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      tooltip: "Delete Course Groups",
                                      onPressed: () {
                                        Get.dialog(
                                            const DeleteCourseGroupScreen());
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
                            child: FutureBuilder(
                              future: dataController.getAllGroups(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  List<GroupModel> data =
                                      snapshot.data as List<GroupModel>;

                                  if (data.isEmpty) {
                                    return Center(
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: const Text(
                                            "No Data Found !",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    );
                                  } else {
                                    return DataTable2(
                                      headingTextStyle: const TextStyle(
                                          color: Colors.lightGreenAccent,
                                          fontWeight: FontWeight.w500),
                                      dataTextStyle:
                                          const TextStyle(color: Colors.white),
                                      columns: const [
                                        DataColumn2(label: Text("ID")),
                                        DataColumn2(label: Text("Name")),
                                        DataColumn2(
                                            label: Text("Organization ID")),
                                        // DataColumn2(label: Text("Edit/Delete")),
                                      ],
                                      rows: List.generate(data.length, (index) {
                                        return DataRow(cells: [
                                          DataCell(Text(data[index]
                                              .groupName
                                              .toString())),
                                          DataCell(Text(data[index]
                                              .groupName
                                              .toString())),
                                          DataCell(Text(data[index]
                                              .institute
                                              .toString())),
                                        ]);
                                      }),
                                    );
                                  }
                                }
                                return Container();
                              },
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
  }
}
