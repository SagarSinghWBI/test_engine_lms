import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/bulkDataController.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/image_picking_service.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AddBulkQuestions extends StatefulWidget {
  const AddBulkQuestions({Key? key, required this.model}) : super(key: key);

  final List<GetTestModel> model;

  @override
  State<AddBulkQuestions> createState() => _AddBulkQuestionsState();
}

class _AddBulkQuestionsState extends State<AddBulkQuestions> {
  FilePickerResult? questionsData;
  GetTestModel? selectedModel = GetTestModel();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int pendingQuestions = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 450,
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
                            "Add Bulk Questions",
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return "Please select a test to continue.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "Choose Test",
                              hintText: "Choose Test"),
                          value: selectedModel!.questions != null
                              ? selectedModel
                              : null,
                          items: widget.model
                              .where((element) =>
                                  element.questions!.isEmpty ||
                                  element.questions!.length !=
                                      element.totalQuestions)
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text("(${e.testId}) ${e.testName}")))
                              .toList(),
                          onChanged: (value) {
                            selectedModel = value as GetTestModel;
                            pendingQuestions = selectedModel!.totalQuestions! -
                                selectedModel!.questions!.length;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 500,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await ImagePickingService()
                                      .pickExcelFileFromGallery(onSelected:
                                          (FilePickerResult result) {
                                    ///
                                    setState(() {
                                      questionsData = result;
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
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 60),
                                      child: Image.asset(
                                        "lib/assets/questions_vector.png",
                                        height: 70,
                                      ),
                                    ),
                                    Container(
                                      height: 250,
                                      width: 250,
                                      padding: const EdgeInsets.only(
                                          bottom: 40, right: 0),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        questionsData == null
                                            ? "Select Excel File"
                                            : questionsData!.files.first.name,
                                        style: TextStyle(
                                            fontSize:
                                                questionsData != null ? 12 : 12,
                                            color: questionsData == null
                                                ? Colors.white
                                                : Colors.tealAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Visibility(
                              //   visible: widget.model != null,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20),
                              //     ),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           widget.model != null
                              //               ? "Test ID: ${widget.model!.testId}"
                              //               : "",
                              //           style: TextStyle(
                              //               color: Constants.primaryColor,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //         Text(
                              //           widget.model != null
                              //               ? "Test Name: ${widget.model!.testName}"
                              //               : "",
                              //           style: TextStyle(
                              //               color: Constants.primaryColor,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //         Text(
                              //           widget.model != null
                              //               ? "Showed Questions: ${widget.model!.showedQuestion}"
                              //               : "",
                              //           style: TextStyle(
                              //               color: Constants.primaryColor,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )

                              Column(
                                children: [
                                  Visibility(
                                    visible: selectedModel!.questions != null,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Questions:${selectedModel?.totalQuestions}",
                                          style: TextStyle(
                                              color: Constants.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Available Questions:${selectedModel!.questions?.length}",
                                          style: TextStyle(
                                              color: Constants.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Pending Questions:$pendingQuestions",
                                          style: TextStyle(
                                              color: Constants.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Constants.primaryColor),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          )),
                                      onPressed: () async {
                                        ///Download questions format
                                        await launchUrl(Uri.parse(
                                            Constants.bulkQuestionsFormatUrl));
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
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Constants.primaryColor),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          )),
                                      onPressed: () async {
                                        ///video demo bulk questions
                                        await launchUrl(Uri.parse(
                                            Constants.bulkQuestionsUploadDemo));
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
                      ],
                    ),
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
                      if (formKey.currentState!.validate() &&
                          questionsData != null) {
                        ///hit api here
                        BulkDataController().uploadBulkQuestions(
                          filePickerResult: questionsData!,
                          onSuccess: () {
                            setState(() {
                              questionsData = null;
                            });
                          },
                          testId: selectedModel!.testId!,
                        );
                      } else if (questionsData == null) {
                        getErrorDialogue(
                            errorMessage: "Please select a excel file.");
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text("Add Questions")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
