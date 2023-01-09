import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/models/Questions.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditTestScreen extends StatefulWidget {
  const EditTestScreen({Key? key}) : super(key: key);

  @override
  State<EditTestScreen> createState() => _EditTestScreenState();
}

class _EditTestScreenState extends State<EditTestScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<GetTestModel> testList = [];
  GetTestModel? selectedModel;
  int totalQuestions = 0;
  List<Questions> questionsList = [];

  ///controllers
  TextEditingController testNameController = TextEditingController();
  TextEditingController totalQuestionsController = TextEditingController();
  TextEditingController totalTimeController = TextEditingController();

  getAllTests() async {
    try {
      testList = await TestController().getAllAvailableTests();
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("get group Error is:$e");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTests();
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
                            items: testList.map((e) {
                              return DropdownMenuItem<GetTestModel>(
                                value: e,
                                child: Text(
                                    "(${e.testId}) ${e.testName}, ${e.courseId}"),
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
                          onSaved: (String? value) {
                            print("here>>>>>>>");

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
                              labelText: "Total Questions",
                              hintText: "Ex: 10, 50, 100, 200 etc."),
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
                              print("$index");
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ///question
                                    TextFormField(
                                      onChanged: (String? value) {
                                        questionsList[index].question = value;
                                        setState(() {});
                                      },
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
                                    MathField(
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
                                        setState(() {});
                                        print(
                                            "Hit:${questionsList[index].questionExpression}");
                                      },
                                      decoration: getInputDecoration(
                                          labelText: "Question Expression",
                                          hintText: "Ex: (2/3)+(x/y)=23/7"),
                                    ),
                                    const SizedBox(height: 15),
                                    ///////////////////////////////////////////////
                                    ///opt 1
                                    TextFormField(
                                      onChanged: (String? value) {
                                        questionsList[index].option1 = value;
                                        setState(() {});
                                      },
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
                                    MathField(
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
                                        setState(() {});
                                        print(
                                            "Hit:${questionsList[index].expression1}");
                                      },
                                      decoration: getInputDecoration(
                                          labelText: "Option 1 Expression",
                                          hintText: "Ex: (2/3)+(x/y)=23/7"),
                                    ),
                                    const SizedBox(height: 15),
                                    ////////////////////////////////////////////////
                                    ///opt 2
                                    TextFormField(
                                      onChanged: (String? value) {
                                        questionsList[index].option2 = value;
                                        setState(() {});
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
                                    MathField(
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
                                        setState(() {});
                                        print(
                                            "Hit:${questionsList[index].expression2}");
                                      },
                                      decoration: getInputDecoration(
                                          labelText: "Option 2 Expression",
                                          hintText: "Ex: (2/3)+(x/y)=23/7"),
                                    ),
                                    const SizedBox(height: 15),
                                    ////////////////////////////////////////////////
                                    ///opt 3
                                    TextFormField(
                                      onChanged: (String? value) {
                                        questionsList[index].option3 = value;
                                        setState(() {});
                                        print("List:${questionsList.asMap()}");
                                      },
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
                                    MathField(
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
                                        setState(() {});
                                        print(
                                            "Hit:${questionsList[index].expression3}");
                                      },
                                      decoration: getInputDecoration(
                                          labelText: "Option 3 Expression",
                                          hintText: "Ex: (2/3)+(x/y)=23/7"),
                                    ),
                                    const SizedBox(height: 15),
                                    /////////////////////////////////////////////////////
                                    ///opt 4
                                    TextFormField(
                                      onChanged: (String value) {
                                        questionsList[index].option4 = value;
                                        setState(() {});
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
                                    MathField(
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
                                        setState(() {});
                                        print(
                                            "Hit:${questionsList[index].expression4}");
                                      },
                                      decoration: getInputDecoration(
                                          labelText: "Option 4 Expression",
                                          hintText: "Ex: (2/3)+(x/y)=23/7"),
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
                                              value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) {
                                        questionsList[index].correctOpt = value;
                                        setState(() {});
                                      },
                                      value: questionsList[index].correctOpt,
                                    ),
                                  ],
                                ),
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                        print("Questions List:${questionsList.asMap()}");
                        print("1:${questionsList[0].toJson()}");
                        print("2:${questionsList[1].toJson()}");
                        print("3:${questionsList[2].toJson()}");
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text("Add Test")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
