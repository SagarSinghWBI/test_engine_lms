import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class DeleteStudentScreen extends StatefulWidget {
  const DeleteStudentScreen({Key? key}) : super(key: key);

  @override
  State<DeleteStudentScreen> createState() => _DeleteStudentScreenState();
}

class _DeleteStudentScreenState extends State<DeleteStudentScreen> {
  GetStudentsModel? selectedModel;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<GetStudentsModel> allStudents = [];
  var dataController = Get.put(DataController());

  getAllStudents() async {
    try {
      allStudents = await dataController.getAllStudents();
      setState(() {});
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: Get.height / 2.5,
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
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Delete Students",
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonFormField(
                              validator: (value) {
                                if (value == null) {
                                  return "Please choose a Student!";
                                }
                                return null;
                              },
                              isDense: true,
                              decoration: getInputDecoration(
                                labelText: "Select Student",
                                hintText: "",
                              ),
                              items: allStudents.map((e) {
                                return DropdownMenuItem<GetStudentsModel>(
                                  value: e,
                                  child: Text("(${e.studentId}) ${e.userName}"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedModel = value;
                                setState(() {});
                              }),
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
                            backgroundColor: MaterialStatePropertyAll(
                                Constants.primaryColor)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ///hit api here
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text("Delete Student")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
