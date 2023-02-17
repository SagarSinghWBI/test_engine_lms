import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/bulkDataController.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/image_picking_service.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';

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
          height: Get.height / 1.6,
          width: Get.width / 1.6,
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
                child:  InkWell(
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
                        height: 300,
                        width: 300,
                      ),
                      Container(
                        height: 300,
                        width: 300,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 60, top: 50),
                        child: Image.asset(
                          "lib/assets/bulk_student.png",
                          height: 70,
                        ),
                      ),
                      Container(
                        height: 300,
                        width: 300,
                        padding:
                        const EdgeInsets.only(bottom: 40, right: 0),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          studentsData == null
                              ? "Select Excel File"
                              : "File Selected",
                          style: TextStyle(
                              color: studentsData == null
                                  ? Colors.white
                                  : Colors.tealAccent),
                        ),
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
