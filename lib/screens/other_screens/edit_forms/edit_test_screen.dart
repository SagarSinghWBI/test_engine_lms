import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/models/Questions.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditTestScreen extends StatefulWidget {
  const EditTestScreen({Key? key, required this.testList}) : super(key: key);
  final List<GetTestModel> testList;

  @override
  State<EditTestScreen> createState() => _EditTestScreenState();
}

class _EditTestScreenState extends State<EditTestScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GetTestModel? selectedModel;
  int totalQuestions = 0;
  List<Questions> questionsList = [];

  ///controllers
  TextEditingController testNameController = TextEditingController();
  TextEditingController totalQuestionsController = TextEditingController();
  TextEditingController totalTimeController = TextEditingController();
  TextEditingController totalMarksController = TextEditingController();
  TextEditingController showedQuestionsController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    testNameController.dispose();
    totalQuestionsController.dispose();
    totalTimeController.dispose();
    totalMarksController.dispose();
    showedQuestionsController.dispose();
    endDateController.dispose();
    startDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 1.2,
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
                            "Edit Test",
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
                        width: Get.width / 3,
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Please choose a Test!";
                              }
                              return null;
                            },
                            isDense: true,
                            decoration: getInputDecoration(
                                labelText: "Choose a Test", hintText: ""),
                            items: widget.testList.map((e) {
                              return DropdownMenuItem<GetTestModel>(
                                value: e,
                                child: Text("${e.testId}. ${e.testName}"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedModel = value;

                              setState(() {});
                              testNameController.text =
                                  selectedModel!.testName!;
                              totalQuestionsController.text =
                                  selectedModel!.totalQuestions!.toString();
                              totalTimeController.text =
                                  selectedModel!.totalTime!.toString();
                              showedQuestionsController.text =
                                  selectedModel!.showedQuestion!.toString();
                              endDateController.text =
                                  selectedModel!.endDate.toString();
                              totalMarksController.text =
                                  selectedModel!.totalMarks.toString();
                              formKey.currentState?.save();
                            }),
                        const SizedBox(height: 20),

                        ///test name field
                        TextFormField(
                          controller: testNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "New Test Name",
                              hintText:
                                  "Ex: HTML/CSS Test, Algebra Test, General Knowledge Test etc."),
                        ),
                        const SizedBox(height: 20),

                        ///total questions
                        TextFormField(
                          enabled: false,
                          controller: totalQuestionsController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          onSaved: (String? value) {},
                          decoration: getInputDecoration(
                              labelText: "Total Questions",
                              hintText: "Ex: 10, 50, 100, 200 etc."),
                        ),
                        const SizedBox(height: 20),

                        ///showed questions
                        TextFormField(
                          enabled: true,
                          controller: showedQuestionsController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            } else if (int.parse(value) >
                                int.parse(totalQuestionsController.text)) {
                              return "Showed questions cannot be greater than total questions.";
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            if (kDebugMode) {
                              print("here>>>>>>>");
                            }

                            if (value != "0" && value!.isNotEmpty) {
                              questionsList.clear();
                              for (int i = 0; i < int.parse(value); i++) {
                                if (kDebugMode) {
                                  print("${int.parse(value)} ,,, ${i + 1}");
                                }
                                questionsList.add(Questions());
                              }
                              setState(() {
                                totalQuestions = int.parse(value);
                              });
                            } else {
                              setState(() {
                                totalQuestions = 0;
                              });
                            }
                          },
                          decoration: getInputDecoration(
                            labelText: "Showed Questions",
                            hintText: "Ex: 10, 50, 100, 200 etc.",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///total time
                        TextFormField(
                          controller: totalTimeController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Total Time (In Minutes)",
                            hintText: "Ex: 10, 50, 100, 200 etc.",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///total marks
                        TextFormField(
                          controller: totalMarksController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Total Marks ",
                            hintText: "Ex: 10, 50, 100, 200 etc.",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///End Date
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                //context of current state
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              if (kDebugMode) {
                                print(pickedDate);
                              } //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              if (kDebugMode) {
                                print(formattedDate);
                              } //formatted date output using intl package =>  2021-03-16
                              endDateController.text = formattedDate;
                            } else {
                              if (kDebugMode) {
                                print("Date is not selected");
                              }
                            }
                          },
                          child: TextFormField(
                            controller: endDateController,
                            enabled: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field is mandatory to fill.";
                              }
                              return null;
                            },
                            decoration: getInputDecoration(
                              labelText: "End Date ",
                              hintText: "yyyy-MM-dd",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                          MaterialStatePropertyAll(Constants.primaryColor),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                        TestController().updateTestInformation(
                          testId: selectedModel!.testId.toString(),
                          testName: testNameController.text,
                          startDate: selectedModel!.startDate.toString(),
                          endDate: endDateController.text,
                          totalQuestions: selectedModel!.totalQuestions!,
                          totalMarks: int.parse(totalMarksController.text),
                          showedQuestion:
                              int.parse(showedQuestionsController.text),
                          onSuccess: () {
                            formKey.currentState?.reset();
                            selectedModel = GetTestModel();
                            testNameController.text = "";
                            totalQuestionsController.text = "";
                            totalTimeController.text = "";
                            totalMarksController.text = "";
                            showedQuestionsController.text = "";
                            endDateController.text = "";
                            startDateController.text = "";
                          },
                        );
                        // print("Questions List:${questionsList.asMap()}");
                        // print("1:${questionsList[0].toJson()}");
                        // print("2:${questionsList[1].toJson()}");
                        // print("3:${questionsList[2].toJson()}");
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text("Update Test")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
