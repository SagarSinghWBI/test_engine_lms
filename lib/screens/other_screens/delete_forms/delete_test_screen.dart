import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class DeleteTestScreen extends StatefulWidget {
  const DeleteTestScreen({Key? key, required this.allCoursesGroup})
      : super(key: key);
  final List<GetTestModel> allCoursesGroup;

  @override
  State<DeleteTestScreen> createState() => _DeleteTestScreenState();
}

class _DeleteTestScreenState extends State<DeleteTestScreen> {
  GetTestModel? selectedModel;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                                "Delete Test",
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
                                  return "Please choose a Test!";
                                }
                                return null;
                              },
                              isDense: true,
                              decoration: getInputDecoration(
                                labelText: "Select Test",
                                hintText: "",
                              ),
                              items: widget.allCoursesGroup.map((e) {
                                return DropdownMenuItem<GetTestModel>(
                                  value: e,
                                  child: Text("(${e.testId}) ${e.testName}"),
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
                        label: const Text("Delete Test")),
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
