import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/models/AddQuestionsModel.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/image_picking_service.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/storage_service.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({Key? key, required this.testModel})
      : super(key: key);

  final GetTestModel testModel;

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var dataController = Get.put(DataController());
  TextEditingController totalMarksController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController testNameController = TextEditingController();
  TextEditingController totalTimeController = TextEditingController();
  TextEditingController showQuestionsController = TextEditingController();
  TextEditingController pdfController = TextEditingController();
  TextEditingController totalQuestionsController = TextEditingController();

  GroupModel? selectedModel;
  int totalQuestions = 0;
  int questionLimit = 1;
  List<AddQuestionsModel> questionsList = [];
  RxList<RxBool> boolExpressionList = <RxBool>[].obs;
  FilePickerResult? pdfFile;

  @override
  void initState() {
    super.initState();
    totalMarksController.text = widget.testModel.totalMarks.toString();
    endDateController.text = widget.testModel.endDate.toString();
    testNameController.text = widget.testModel.testName.toString();
    totalTimeController.text = widget.testModel.totalTime.toString();
    showQuestionsController.text = widget.testModel.showedQuestion.toString();
    totalQuestionsController.text = widget.testModel.totalQuestions.toString();
  }

  @override
  void dispose() {
    super.dispose();
    endDateController.dispose();
    testNameController.dispose();
    totalTimeController.dispose();
    showQuestionsController.dispose();
    pdfController.dispose();
    totalQuestionsController.dispose();
    totalMarksController.dispose();
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
                            "Add Test Questions",
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

                        ///test name field
                        TextFormField(
                          controller: testNameController,
                          enabled: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Test Name",
                            hintText:
                                "Ex: HTML/CSS Test, Algebra Test, General Knowledge Test etc.",
                          ),
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
                            // else if (int.parse(value) > questionLimit) {
                            //   getUpgradeSubscriptionDialog();
                            //   return "Your question limit is $questionLimit. Upgrade your subscription for increasing limit.";
                            // }
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
                                questionsList.add(AddQuestionsModel());
                                boolExpressionList.add(false.obs);
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
                              labelText: "Total Questions",
                              hintText: "Ex: 10, 50, 100, 200 etc."),
                        ),
                        const SizedBox(height: 20),

                        ///showed questions
                        TextFormField(
                          enabled: false,
                          controller: showQuestionsController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            } else if (int.parse(value) >
                                int.parse(totalQuestionsController.text)) {
                              return "Showed Questions cannot be more than Total Questions.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Total Showed Questions",
                            hintText: "Ex: 10, 50, 100, 200 etc.",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///total marks
                        TextFormField(
                          enabled: false,
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
                            labelText: "Total Marks",
                            hintText: "Ex: 10, 50, 100, 200 etc.",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///total time
                        TextFormField(
                          enabled: false,
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

                        ///End Date
                        GestureDetector(
                          onTap: () async {
                            // DateTime? pickedDate = await showDatePicker(
                            //     context: context,
                            //     //context of current state
                            //     initialDate: DateTime.now(),
                            //     firstDate: DateTime.now(),
                            //     //DateTime.now() - not to allow to choose before today.
                            //     lastDate: DateTime(2101));
                            //
                            // if (pickedDate != null) {
                            //   if (kDebugMode) {
                            //     print(pickedDate);
                            //   } //pickedDate output format => 2021-03-10 00:00:00.000
                            //   String formattedDate =
                            //       DateFormat('yyyy-MM-dd').format(pickedDate);
                            //   if (kDebugMode) {
                            //     print(formattedDate);
                            //   } //formatted date output using intl package =>  2021-03-16
                            //   endDateController.text = formattedDate;
                            // } else {
                            //   if (kDebugMode) {
                            //     print("Date is not selected");
                            //   }
                            // }
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

                        const SizedBox(height: 15),

                        const SizedBox(height: 20),

                        ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.indigo)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (totalQuestions == 0) {
                                  Get.defaultDialog(
                                      title: "Alert",
                                      titleStyle: const TextStyle(
                                        color: Colors.red,
                                      ),
                                      content: const Center(
                                        child: Text(
                                            "Please make sure that you have been entered the number of total questions!"),
                                      ),
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.indigo,
                                      onConfirm: () {
                                        Get.back();
                                      });
                                }
                              }
                            },
                            child: const Text("Enter Questions")),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: totalQuestions != 0,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: totalQuestions,
                            itemBuilder: (context, index) {
                              if (kDebugMode) {
                                print("$index");
                              }
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Obx(() {
                                  return Column(
                                    children: [
                                      ///boolean for expression
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              activeColor:
                                                  Constants.primaryColor,
                                              value: boolExpressionList[index]
                                                  .value,
                                              onChanged: (value) {
                                                boolExpressionList[index]
                                                    .value = value!;
                                              },
                                            ),
                                            Text("Have Expressions?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Constants
                                                        .primaryColor)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      ///question
                                      TextFormField(
                                        onSaved: (String? value) {
                                          questionsList[index].question = value;
                                          // setState(() {});
                                        },
                                        // onChanged: (String? value) {
                                        //   questionsList[index].question = value;
                                        //   setState(() {});
                                        // },
                                        initialValue:
                                            questionsList[index].question ?? "",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is mandatory to fill.";
                                          }
                                          return null;
                                        },
                                        decoration: getInputDecoration(
                                            labelText: "Question ${index + 1}",
                                            hintText: "Ex: What is Software?"),
                                      ),
                                      const SizedBox(height: 10),

                                      ///question expression
                                      Visibility(
                                        visible:
                                            boolExpressionList[index].value,
                                        child: MathField(
                                          variables: const [
                                            "a",
                                            "b",
                                            "c",
                                            "x",
                                            "y",
                                            "z"
                                          ],
                                          onChanged: (value) {
                                            questionsList[index]
                                                .questionExpression = value;
                                            // setState(() {});
                                            if (kDebugMode) {
                                              print(
                                                  "Hit:${questionsList[index].questionExpression}");
                                            }
                                          },
                                          decoration: getInputDecoration(
                                              labelText: "Question Expression",
                                              hintText: "Ex: (2/3)+(x/y)=23/7"),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      ///////////////////////////////////////////////
                                      ///opt 1
                                      TextFormField(
                                        onSaved: (String? value) {
                                          questionsList[index].option1 = value;
                                          // setState(() {});
                                        },
                                        // onChanged: (String? value) {
                                        //   questionsList[index].option1 = value;
                                        //   setState(() {});
                                        // },
                                        initialValue:
                                            questionsList[index].option1 ?? "",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is mandatory to fill.";
                                          }
                                          return null;
                                        },
                                        decoration: getInputDecoration(
                                            labelText: "Option 1",
                                            hintText:
                                                "Ex: Software is a set of instructions, data or programs used to operate computers and execute specific tasks."),
                                      ),
                                      const SizedBox(height: 10),

                                      ///opt1 expression
                                      Visibility(
                                        visible:
                                            boolExpressionList[index].value,
                                        child: MathField(
                                          variables: const [
                                            "a",
                                            "b",
                                            "c",
                                            "x",
                                            "y",
                                            "z"
                                          ],
                                          onChanged: (value) {
                                            questionsList[index].expression1 =
                                                value;
                                            // setState(() {});
                                            if (kDebugMode) {
                                              print(
                                                  "Hit:${questionsList[index].expression1}");
                                            }
                                          },
                                          decoration: getInputDecoration(
                                              labelText: "Option 1 Expression",
                                              hintText: "Ex: (2/3)+(x/y)=23/7"),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      ////////////////////////////////////////////////
                                      ///opt 2
                                      TextFormField(
                                        // onChanged: (String? value) {
                                        //   questionsList[index].option2 = value;
                                        //   setState(() {});
                                        // },
                                        onSaved: (String? value) {
                                          questionsList[index].option2 = value;
                                          // setState(() {});
                                        },
                                        initialValue:
                                            questionsList[index].option2 ?? "",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is mandatory to fill.";
                                          }
                                          return null;
                                        },
                                        decoration: getInputDecoration(
                                            labelText: "Option 2",
                                            hintText:
                                                "Ex: Software is a set of instructions, data or programs used to operate computers and execute specific tasks."),
                                      ),
                                      const SizedBox(height: 10),

                                      ///opt2 expression
                                      Visibility(
                                        visible:
                                            boolExpressionList[index].value,
                                        child: MathField(
                                          variables: const [
                                            "a",
                                            "b",
                                            "c",
                                            "x",
                                            "y",
                                            "z"
                                          ],
                                          onChanged: (value) {
                                            questionsList[index].expression2 =
                                                value;
                                            // setState(() {});
                                            if (kDebugMode) {
                                              print(
                                                  "Hit:${questionsList[index].expression2}");
                                            }
                                          },
                                          decoration: getInputDecoration(
                                              labelText: "Option 2 Expression",
                                              hintText: "Ex: (2/3)+(x/y)=23/7"),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      ////////////////////////////////////////////////
                                      ///opt 3
                                      TextFormField(
                                        onSaved: (String? value) {
                                          questionsList[index].option3 = value;
                                          // setState(() {});
                                          if (kDebugMode) {
                                            print(
                                                "List:${questionsList.asMap()}");
                                          }
                                        },
                                        // onChanged: (String? value) {
                                        //   questionsList[index].option3 = value;
                                        //   setState(() {});
                                        //   if (kDebugMode) {
                                        //     print(
                                        //         "List:${questionsList.asMap()}");
                                        //   }
                                        // },
                                        initialValue:
                                            questionsList[index].option3 ?? "",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is mandatory to fill.";
                                          }
                                          return null;
                                        },
                                        decoration: getInputDecoration(
                                            labelText: "Option 3",
                                            hintText:
                                                "Ex: Software is a set of instructions, data or programs used to operate computers and execute specific tasks."),
                                      ),
                                      const SizedBox(height: 10),

                                      ///opt3 expression
                                      Visibility(
                                        visible:
                                            boolExpressionList[index].value,
                                        child: MathField(
                                          variables: const [
                                            "a",
                                            "b",
                                            "c",
                                            "x",
                                            "y",
                                            "z"
                                          ],
                                          onChanged: (value) {
                                            questionsList[index].expression3 =
                                                value;
                                            // setState(() {});
                                            if (kDebugMode) {
                                              print(
                                                  "Hit:${questionsList[index].expression3}");
                                            }
                                          },
                                          decoration: getInputDecoration(
                                              labelText: "Option 3 Expression",
                                              hintText: "Ex: (2/3)+(x/y)=23/7"),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      /////////////////////////////////////////////////////
                                      ///opt 4
                                      TextFormField(
                                        onSaved: (value) {
                                          questionsList[index].option4 = value;
                                          // setState(() {});
                                        },
                                        onChanged: (String value) {
                                          formKey.currentState?.save();
                                          // questionsList[index].option4 = value;
                                          // setState(() {});
                                        },
                                        initialValue:
                                            questionsList[index].option4 ?? "",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is mandatory to fill.";
                                          }
                                          return null;
                                        },
                                        decoration: getInputDecoration(
                                            labelText: "Option 4",
                                            hintText:
                                                "Ex: Software is a set of instructions, data or programs used to operate computers and execute specific tasks."),
                                      ),
                                      const SizedBox(height: 10),

                                      ///opt4 expression
                                      Visibility(
                                        visible:
                                            boolExpressionList[index].value,
                                        child: MathField(
                                          variables: const [
                                            "a",
                                            "b",
                                            "c",
                                            "x",
                                            "y",
                                            "z"
                                          ],
                                          onChanged: (value) {
                                            questionsList[index].expression4 =
                                                value;
                                            // setState(() {});
                                            if (kDebugMode) {
                                              print(
                                                  "Hit:${questionsList[index].expression4}");
                                            }
                                          },
                                          decoration: getInputDecoration(
                                            labelText: "Option 4 Expression",
                                            hintText: "Ex: (2/3)+(x/y)=23/7",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      ////////////////////////////////////////////////////
                                      ///choose correct option
                                      DropdownButtonFormField(
                                        decoration: getInputDecoration(
                                          labelText: "Choose Correct Option",
                                          hintText: "Choose Answer",
                                        ),
                                        items: [
                                          questionsList[index].option1 ?? "A",
                                          questionsList[index].option2 ?? "B",
                                          questionsList[index].option3 ?? "C",
                                          questionsList[index].option4 ?? "D",
                                        ]
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          questionsList[index].correctOpt =
                                              value;
                                          // questionsList[index].correctOpt =
                                          //     value;
                                          // setState(() {});
                                        },
                                        onSaved: (value) {
                                          questionsList[index].correctOpt =
                                              value;
                                          // setState(() {});
                                        },
                                        value: questionsList[index].correctOpt,
                                      ),
                                    ],
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
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
                    onPressed: () async {
                      // if(questionsList.is) {
                      //   formKey.currentState?.save();
                      // }
                      if (formKey.currentState!.validate()) {
                        ///check for current month limit
                        formKey.currentState?.save();
                        int testLimit =
                            await DataController().getInstituteTestData();

                        String tests =
                            await StorageService().getData(key: "totalTests");
                        int totalTests = int.parse(tests);
                        if (totalTests > testLimit) {
                          getUpgradeSubscriptionDialog();
                        } else {
                          ///hit api here

                          for (int i = 0; i < questionsList.length; i++) {
                            await DataController().addAQuestionInTest(
                              question: questionsList[i].question.toString(),
                              questionExpression: questionsList[i]
                                  .questionExpression
                                  .toString(),
                              option1: questionsList[i].option1.toString(),
                              option2: questionsList[i].option2.toString(),
                              option3: questionsList[i].option3.toString(),
                              option4: questionsList[i].option4.toString(),
                              correctOpt:
                                  questionsList[i].correctOpt.toString(),
                              testId: widget.testModel.testId!,
                              onSuccess: () {
                                print("Success");
                                if (i == questionsList.length - 1) {
                                  Get.back();
                                  getSuccessDialogue(
                                      message: "Questions Added Successfully.");
                                }
                              },
                            );
                          }
                          // questionsList.forEach((element) async {
                          //   // Future.delayed(Duration(seconds: 2));
                          //   await DataController().addAQuestionInTest(
                          //       question: element.question.toString(),
                          //       questionExpression:
                          //           element.questionExpression.toString(),
                          //       option1: element.option1.toString(),
                          //       option2: element.option2.toString(),
                          //       option3: element.option3.toString(),
                          //       option4: element.option4.toString(),
                          //       correctOpt: element.correctOpt.toString(),
                          //       testId: widget.testModel.testId!,
                          //       onSuccess: () {
                          //         print("Success");
                          //       });
                          // });
                        }

                        /// ///////////////////
                        // print("Questions List:${questionsList.asMap()}");
                        // print("1:${questionsList[0].toJson()}");
                        // print("2:${questionsList[1].toJson()}");
                        // print("3:${questionsList[2].toJson()}");
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text("Save Test Questions")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
