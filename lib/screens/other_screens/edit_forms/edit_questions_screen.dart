import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/edit_questions_controller.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditQuestionsScreen extends StatefulWidget {
  const EditQuestionsScreen({Key? key, required this.testList})
      : super(key: key);
  final List<GetTestModel> testList;

  @override
  State<EditQuestionsScreen> createState() => _EditQuestionsScreenState();
}

class _EditQuestionsScreenState extends State<EditQuestionsScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showQuestions = false;
  String selectedTest = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetX<EditQuestionsController>(
        initState: (state) {},
        builder: (controller) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              height: Get.height / 1.10,
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
                                "Edit Questions",
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///select test to edit questions
                          Visibility(
                            visible: !showQuestions,
                            child: Column(
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
                                        labelText: "Choose a Test",
                                        hintText: ""),
                                    items: widget.testList.map((e) {
                                      return DropdownMenuItem<GetTestModel>(
                                        value: e,
                                        child:
                                            Text("${e.testId}. ${e.testName}"),
                                      );
                                    }).toList(),
                                    onSaved: (value) {},
                                    onChanged: (value) {
                                      selectedTest = value!.testName.toString();
                                      controller.updateQuestionList(
                                          value: value);
                                      showQuestions = true;
                                      setState(() {});

                                      print(
                                          "Called.............${controller.questionsList[0].option1}");

                                      // formKey.currentState?.save();
                                    }),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: showQuestions,
                              child: Column(
                                children: [
                                  Text(
                                    "Selected test is: $selectedTest",
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    width: Get.width / 5,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                            visible: showQuestions,
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: controller.questionsList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 15),
                                    width: Get.width,
                                    // height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Constants.primaryColor),
                                    ),
                                    child: Form(
                                      key: controller.formKeys[index],
                                      child: Column(
                                        children: [
                                          ///question text field
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "This Field is mandatory to fill.";
                                              }
                                              return null;
                                            },
                                            initialValue: controller
                                                .questionsList[index].question,
                                            decoration: getInputDecoration(
                                                labelText:
                                                    "Question ${index + 1}",
                                                hintText: "What is Software?"),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                  .question = value.toString();
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          ///opt 1 text field
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "This Field is mandatory to fill.";
                                              }
                                              return null;
                                            },
                                            initialValue: controller
                                                .questionsList[index].option1,
                                            decoration: getInputDecoration(
                                                labelText: "Option 1",
                                                hintText: ""),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                  .option1 = value.toString();
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          ///opt 2 text field
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "This Field is mandatory to fill.";
                                              }
                                              return null;
                                            },
                                            initialValue: controller
                                                .questionsList[index].option2,
                                            decoration: getInputDecoration(
                                                labelText: "Option 2",
                                                hintText: ""),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                  .option2 = value.toString();
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          ///opt 3 text field
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "This Field is mandatory to fill.";
                                              }
                                              return null;
                                            },
                                            initialValue: controller
                                                .questionsList[index].option3,
                                            decoration: getInputDecoration(
                                              labelText: "Option 3",
                                              hintText: "",
                                            ),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                  .option3 = value.toString();
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          ///opt 4 text field
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "This Field is mandatory to fill.";
                                              }
                                              return null;
                                            },
                                            initialValue: controller
                                                .questionsList[index].option4,
                                            decoration: getInputDecoration(
                                              labelText: "Option 4",
                                              hintText: "",
                                            ),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                  .option4 = value.toString();
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          Text(
                                            "Previous answer: ${controller.questionsList[index].correctOpt}",
                                            style: TextStyle(
                                                color: Constants.primaryColor),
                                          ),

                                          ///correct option
                                          DropdownButtonFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please choose correct option.";
                                              }
                                              return null;
                                            },
                                            decoration: getInputDecoration(
                                              labelText:
                                                  "Choose Correct Option",
                                              hintText: "Choose Answer",
                                            ),
                                            items: [
                                              controller.questionsList[index]
                                                          .option1 ==
                                                      "null"
                                                  ? "A"
                                                  : controller
                                                      .questionsList[index]
                                                      .option1,
                                              controller.questionsList[index]
                                                          .option2 ==
                                                      "null"
                                                  ? "B"
                                                  : controller
                                                      .questionsList[index]
                                                      .option2,
                                              controller.questionsList[index]
                                                          .option3 ==
                                                      "null"
                                                  ? "C"
                                                  : controller
                                                      .questionsList[index]
                                                      .option3,
                                              controller.questionsList[index]
                                                          .option4 ==
                                                      "null"
                                                  ? "D"
                                                  : controller
                                                      .questionsList[index]
                                                      .option4,
                                            ].map((e) {
                                              return DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              controller.questionsList[index]
                                                      .correctOpt =
                                                  value.toString();
                                            },
                                          ),

                                          const SizedBox(height: 10),
                                          ElevatedButton.icon(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Constants.primaryColor),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20))),
                                              ),
                                              onPressed: () {
                                                if (controller.formKeys[index]
                                                    .currentState!
                                                    .validate()) {
                                                  ///hit question update api here
                                                  controller.updateQuestion(
                                                    questionId: controller
                                                        .questionsList[index]
                                                        .questionId,
                                                    onSuccess: () {
                                                      getSuccessDialogue(
                                                          message:
                                                              "Question ${index + 1} Updated Successfully.");
                                                    },
                                                    question: controller
                                                        .questionsList[index]
                                                        .question,
                                                    questionExpression:
                                                        controller
                                                            .questionsList[
                                                                index]
                                                            .questionExpression,
                                                    option1: controller
                                                        .questionsList[index]
                                                        .option1,
                                                    expression1: controller
                                                        .questionsList[index]
                                                        .expression1,
                                                    option2: controller
                                                        .questionsList[index]
                                                        .option2,
                                                    expression2: controller
                                                        .questionsList[index]
                                                        .expression2,
                                                    option3: controller
                                                        .questionsList[index]
                                                        .option3,
                                                    expression3: controller
                                                        .questionsList[index]
                                                        .expression3,
                                                    option4: controller
                                                        .questionsList[index]
                                                        .option4,
                                                    expression4: controller
                                                        .questionsList[index]
                                                        .expression4,
                                                    correctOpt: controller
                                                        .questionsList[index]
                                                        .correctOpt,
                                                    correctExpression:
                                                        controller
                                                            .questionsList[
                                                                index]
                                                            .correctExpression,
                                                    description: controller
                                                        .questionsList[index]
                                                        .description,
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.edit_note,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                  "Update Question: ${index + 1}")),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                              MaterialStatePropertyAll(Constants.primaryColor),
                        ),
                        onPressed: () {
                          Get.back();
                          // if (formKey.currentState!.validate()) {
                          //   ///hit api here
                          //   // TestController().updateTestInformation(
                          //   //   testId: selectedModel!.testId.toString(),
                          //   //   testName: testNameController.text,
                          //   //   startDate: selectedModel!.startDate.toString(),
                          //   //   endDate: endDateController.text,
                          //   //   totalQuestions: selectedModel!.totalQuestions!,
                          //   //   totalMarks: int.parse(totalMarksController.text),
                          //   //   showedQuestion:
                          //   //       int.parse(showedQuestionsController.text),
                          //   //   onSuccess: () {
                          //   //     formKey.currentState?.reset();
                          //   //     selectedModel = GetTestModel();
                          //   //     testNameController.text = "";
                          //   //     totalQuestionsController.text = "";
                          //   //     totalTimeController.text = "";
                          //   //     totalMarksController.text = "";
                          //   //     showedQuestionsController.text = "";
                          //   //     endDateController.text = "";
                          //   //     startDateController.text = "";
                          //   //   },
                          //   // );
                          //   ///print answers
                          //   // print("Questions List:${questionsList.asMap()}");
                          //   // print("1:${questionsList[0].toJson()}");
                          //   // print("2:${questionsList[1].toJson()}");
                          //   // print("3:${questionsList[2].toJson()}");
                          // }
                        },
                        icon: const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text("Update Completed")),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
