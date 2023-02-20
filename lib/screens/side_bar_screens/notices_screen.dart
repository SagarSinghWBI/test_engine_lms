import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/screens/other_screens/add_forms/add_notice_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<DataController>(
      initState: (state) {
        if (state.controller!.filteredNotificationModelList.isEmpty) {
          state.controller?.getAllNotifications();
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
                    icon: const Icon(Icons.add, size: 25, color: Colors.white),
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
                              child: const Text("Available Notices",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent)),
                            ),
                            Spacer(),
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
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              getSearchButton(
                                labelText: "Search for Notices",
                                hintText: "Ex:- 16-02-2023, Test Notice",
                                onChanged: (value) {
                                  ///filter list here
                                  controller.filteredNotificationModelList
                                      .clear();
                                  controller.notificationModelList
                                      .forEach((element) {
                                    if (element
                                        .toJson()
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      controller.filteredNotificationModelList
                                          .add(element);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 10),

                              Expanded(
                                  child: controller.searchingNotices.value
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
                                      : controller.filteredNotificationModelList
                                              .isEmpty
                                          ? Center(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                  fontWeight: FontWeight.bold),
                                              dataTextStyle: TextStyle(
                                                  color: Constants.dataColor,
                                                  fontWeight: FontWeight.w400),
                                              columns: const [
                                                DataColumn2(label: Text("ID")),
                                                DataColumn2(
                                                    label:
                                                        Text("Notification")),
                                                DataColumn2(
                                                    label: Text("Date")),
                                                DataColumn2(
                                                    label: Text("Time")),
                                                DataColumn2(
                                                    label: Text("View")),
                                                DataColumn2(
                                                    label: Text("Delete")),

                                                // DataColumn2(label: Text("Delete")),
                                              ],
                                              rows: List.generate(
                                                  controller
                                                      .filteredNotificationModelList
                                                      .length, (index) {
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                    controller
                                                        .filteredNotificationModelList[
                                                            index]
                                                        .noticeId
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Constants.headerColor,
                                                    ),
                                                  )),
                                                  DataCell(Text(
                                                    controller
                                                        .filteredNotificationModelList[
                                                            index]
                                                        .content
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  DataCell(Text(DateFormat(
                                                          "dd-MM-yyyy")
                                                      .format(DateTime.parse(
                                                          controller
                                                              .filteredNotificationModelList[
                                                                  index]
                                                              .noticeDate
                                                              .toString())))),
                                                  DataCell(Text(controller
                                                      .filteredNotificationModelList[
                                                          index]
                                                      .noticeTime
                                                      .toString())),
                                                  DataCell(IconButton(
                                                    tooltip: "View",
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                          title: "Notification",
                                                          titleStyle: TextStyle(
                                                              color: Constants
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          content: Center(
                                                            child: Text(
                                                              controller
                                                                  .filteredNotificationModelList[
                                                                      index]
                                                                  .content
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          buttonColor: Constants
                                                              .primaryColor,
                                                          confirmTextColor:
                                                              Colors.white,
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
                                                  DataCell(
                                                    IconButton(
                                                        tooltip: "Delete",
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          size: 18,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                ]);
                                              }),
                                            )),
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
