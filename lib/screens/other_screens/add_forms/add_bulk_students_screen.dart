import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/bulkDataController.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/image_picking_service.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class AddBulkStudents extends StatefulWidget {
  const AddBulkStudents({Key? key}) : super(key: key);

  @override
  State<AddBulkStudents> createState() => _AddBulkStudentsState();
}

class _AddBulkStudentsState extends State<AddBulkStudents> {
  FilePickerResult? studentsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 400,
          width: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Add Bulk Students",
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
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      tooltip: "Cancel",
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await ImagePickingService().pickExcelFileFromGallery(
                              onSelected: (FilePickerResult result) {
                            ///
                            setState(() {
                              studentsData = result;
                            });
                          });
                        },
                        child: Stack(
                          // alignment: Alignment.topLeft,
                          children: [
                            Image.asset(
                              "lib/assets/excel_sheet_icon.png",
                              fit: BoxFit.fill,
                              height: 250,
                              width: 250,
                            ),
                            Container(
                              height: 250,
                              width: 250,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 50, top: 50),
                              child: Image.asset(
                                "lib/assets/bulk_student.png",
                                height: 70,
                              ),
                            ),
                            Container(
                              height: 250,
                              width: 250,
                              padding:
                                  const EdgeInsets.only(bottom: 40, right: 0),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                studentsData == null
                                    ? "Select Excel File"
                                    : studentsData!.files.first.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: studentsData == null
                                        ? Colors.white
                                        : Colors.tealAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Constants.primaryColor),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                              onPressed: () async {
                                ///Download student format
                                await launchUrl(
                                    Uri.parse(Constants.bulkStudentFormatUrl));
                              },
                              icon: const Icon(
                                Icons.download,
                              ),
                              label: const Text(
                                "Download Format",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Constants.primaryColor),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                              onPressed: () async {
                                ///student bulk upload video url
                                await launchUrl(
                                    Uri.parse(Constants.bulkStudentUploadDemo));
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                              ),
                              label: const Text(
                                "View Demo",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: Get.width,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Constants.primaryColor)),
                    onPressed: () {
                      if (studentsData != null) {
                        ///hit api here
                        BulkDataController().uploadBulkStudents(
                          filePickerResult: studentsData!,
                          onSuccess: () {
                            setState(() {
                              studentsData = null;
                            });
                          },
                        );
                      } else {
                        getErrorDialogue(
                            errorMessage: "Please select a excel file.");
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text("Add Student")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
