import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class AssignStudentCourseScreen extends StatefulWidget {
  const AssignStudentCourseScreen({Key? key}) : super(key: key);

  @override
  State<AssignStudentCourseScreen> createState() =>
      _AssignStudentCourseScreenState();
}

class _AssignStudentCourseScreenState extends State<AssignStudentCourseScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GetStudentsModel? selectedModel;
  List<GetStudentsModel> studentsList = [];
  List<GetStudentsModel> selectedStudents = [];
  List<GroupModel> groupCoursesList = [];
  List<GroupModel> selectedCourses = [];
  var dataController=Get.put(DataController());

  getAllStudents() async {
    try {
      studentsList = await dataController.getAllStudents();
      setState(() {});
    } catch (e) {
      print("Error get students:$e");
    }
  }

  getAllCourses() async {
    try {
      groupCoursesList = await dataController.getAllGroups();
      setState(() {});
    } catch (e) {
      print("Error get courses:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudents();
    getAllCourses();
  }

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
                            "Assign Course Group to Students",
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///select all students
                        Row(
                          children: [
                            Checkbox(
                                value: selectedStudents.length ==
                                    studentsList.length,
                                onChanged: (value) {
                                  if (value == true) {
                                    if (kDebugMode) {
                                      print("here");
                                    }
                                    selectedStudents = studentsList;
                                    setState(() {});
                                  } else {
                                    if (kDebugMode) {
                                      print("there");
                                    }
                                    selectedStudents = [];
                                    setState(() {});
                                  }
                                }),
                            const Text("Select All students"),
                          ],
                        ),

                        ///multiple student field
                        Visibility(
                          visible:
                              selectedStudents.length != studentsList.length,
                          child: MultiSelectFormField(
                            // required: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Constants.primaryColor,
                                )),
                            title: Text(
                              "Select Students",
                              style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            checkBoxActiveColor: Constants.primaryColor,
                            dialogShapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please select a student.";
                              }
                              return null;
                            },
                            dataSource:
                                List.generate(studentsList.length, (index) {
                              return {
                                "display":
                                    "(${studentsList[index].studentId}) ${studentsList[index].userName}",
                                "value": studentsList[index]
                              };
                            }),
                            valueField: "value",
                            textField: "display",
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            // hintWidget: const Text('Select Multiple students'),
                            onSaved: (value) {
                              if (value == null) return;
                              List data = value;
                              setState(() {
                                selectedStudents =
                                    List<GetStudentsModel>.from(data);
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        ///select all courses
                        Row(
                          children: [
                            Checkbox(
                                value: selectedCourses.length ==
                                    groupCoursesList.length,
                                onChanged: (value) {
                                  if (value == true) {
                                    if (kDebugMode) {
                                      print("here");
                                    }
                                    selectedCourses = groupCoursesList;
                                    setState(() {});
                                  } else {
                                    if (kDebugMode) {
                                      print("there");
                                    }
                                    selectedCourses = [];
                                    setState(() {});
                                  }
                                }),
                            const Text("Select All Course Groups"),
                          ],
                        ),

                        ///multiple courses field
                        Visibility(
                          visible: selectedCourses != groupCoursesList,
                          child: MultiSelectFormField(
                            // required: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Constants.primaryColor,
                                )),
                            title: Text(
                              "Select Courses",
                              style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            checkBoxActiveColor: Constants.primaryColor,
                            dialogShapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please select at least a Course.";
                              }
                              return null;
                            },
                            dataSource:
                                List.generate(groupCoursesList.length, (index) {
                              return {
                                "display":
                                    "(${groupCoursesList[index].groupId}) ${groupCoursesList[index].groupName}",
                                "value": groupCoursesList[index]
                              };
                            }),
                            valueField: "value",
                            textField: "display",
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            // hintWidget: const Text('Select Multiple students'),
                            onSaved: (value) {
                              if (value == null) return;
                              List data = value;
                              setState(() {
                                selectedCourses = List<GroupModel>.from(data);
                              });
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
                            MaterialStatePropertyAll(Constants.primaryColor)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                      }
                    },
                    icon: const Icon(
                      Icons.add_card_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text("Assign Course Group to Students")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
