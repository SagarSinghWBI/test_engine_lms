import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class DeleteCourseGroupScreen extends StatefulWidget {
  const DeleteCourseGroupScreen({Key? key, required this.groupList})
      : super(key: key);

  final List<GroupModel> groupList;

  @override
  State<DeleteCourseGroupScreen> createState() =>
      _DeleteCourseGroupScreenState();
}

class _DeleteCourseGroupScreenState extends State<DeleteCourseGroupScreen> {
  GroupModel? selectedModel;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var dataController = Get.put(DataController());

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
                                "Delete Course Group",
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
                                  return "Please choose a Course Group!";
                                }
                                return null;
                              },
                              isDense: true,
                              decoration: getInputDecoration(
                                labelText: "Select Course Group",
                                hintText: "",
                              ),
                              items: widget.groupList.map((e) {
                                return DropdownMenuItem<GroupModel>(
                                  value: e,
                                  child: Text("(${e.groupId}) ${e.groupName}"),
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
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text("Delete Course Group")),
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
