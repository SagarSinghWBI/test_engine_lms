import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetNotificationModel.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_notice_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  var dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Notifications Section:",
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
                width: Get.width,
                text: "Add a Notice",
                onTap: () {
                  Get.dialog(const AddNoticeScreen());
                }),
            // const SizedBox(height: 10),
            // MyButton(width: Get.width, text: "Add Bulk Students", onTap: () {}),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                height: Get.height / 1.6,
                // width: Get.width/3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.indigoAccent, Colors.blue]),
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
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 18,
                                  color: Colors.white,
                                )),
                            // IconButton(
                            //     tooltip: "Assign courses",
                            //     onPressed: () {
                            //       Get.dialog(const AssignStudentCourseScreen());
                            //     },
                            //     icon: const Icon(
                            //       Icons.add_card_rounded,
                            //       size: 18,
                            //       color: Colors.white,
                            //     )),
                            // IconButton(
                            //     tooltip: "Edit Student Data",
                            //     onPressed: () {
                            //       Get.dialog(const EditStudentScreen());
                            //     },
                            //     icon: const Icon(
                            //       Icons.edit,
                            //       size: 18,
                            //       color: Colors.white,
                            //     )),
                            // IconButton(
                            //     tooltip: "Delete Students",
                            //     onPressed: () {
                            //       Get.dialog(const DeleteStudentScreen());
                            //     },
                            //     icon: const Icon(
                            //       Icons.delete,
                            //       color: Colors.white,
                            //       size: 18,
                            //     )),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: dataController.getAllNotifications(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<GetNotificationModel> data =
                                snapshot.data as List<GetNotificationModel>;

                            if (data.isEmpty) {
                              return Center(
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                  DataColumn2(label: Text("Notification")),
                                  DataColumn2(label: Text("Date")),
                                  DataColumn2(label: Text("Time")),
                                  DataColumn2(label: Text("View")),
                                  // DataColumn2(label: Text("Delete")),
                                ],
                                rows: List.generate(data.length, (index) {
                                  return DataRow(cells: [
                                    DataCell(
                                        Text(data[index].noticeId.toString())),
                                    DataCell(Text(
                                      data[index].content.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    DataCell(Text(DateFormat("dd-MM-yyyy")
                                        .format(DateTime.parse(data[index]
                                            .noticeDate
                                            .toString())))),
                                    DataCell(Text(
                                        data[index].noticeTime.toString())),
                                    DataCell(IconButton(
                                      tooltip: "View",
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "Notification",
                                            titleStyle: TextStyle(
                                                color: Constants.primaryColor,
                                                fontWeight: FontWeight.bold),
                                            content: Center(
                                              child: Text(
                                                data[index].content.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            buttonColor: Constants.primaryColor,
                                            confirmTextColor: Colors.white,
                                            onConfirm: () {
                                              Get.back();
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.remove_red_eye,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    )),
                                    // DataCell(
                                    //   IconButton(
                                    //       tooltip: "Delete",
                                    //       onPressed: () {},
                                    //       icon: const Icon(
                                    //         Icons.delete,
                                    //         size: 18,
                                    //         color: Colors.white,
                                    //       )),
                                    // ),
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
    );
  }
}
