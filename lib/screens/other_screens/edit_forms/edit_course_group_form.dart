import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditGroupCourseScreen extends StatefulWidget {
  const EditGroupCourseScreen({Key? key, required this.groupCourses})
      : super(key: key);
  final List<GroupModel> groupCourses;

  @override
  State<EditGroupCourseScreen> createState() => _EditGroupCourseScreenState();
}

class _EditGroupCourseScreenState extends State<EditGroupCourseScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GroupModel? selectedModel;

  ///controllers
  TextEditingController courseNameController = TextEditingController();

  var dataController = Get.put(DataController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    courseNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 2,
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
                            "Edit Group",
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
                        DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return "Please choose a Course Group!";
                            }
                            return null;
                          },
                          isDense: true,
                          decoration: getInputDecoration(
                            labelText: "Select Group",
                            hintText: "",
                          ),
                          items: widget.groupCourses.map((e) {
                            return DropdownMenuItem<GroupModel>(
                              value: e,
                              child: Text(e.groupName.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedModel = value;
                            setState(() {});
                            courseNameController.text =
                                selectedModel!.groupName!;
                          },
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 20),

                        ///course field
                        TextFormField(
                          controller: courseNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "New Group Name",
                            hintText:
                                "Ex: Web Development, Communication, Economics etc.",
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
                            MaterialStatePropertyAll(Constants.primaryColor)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                        dataController.updateGroup(
                            model: selectedModel!,
                            newGroupName: courseNameController.text,
                            onSuccess: () {
                              formKey.currentState?.reset();
                              courseNameController.text = "";
                              selectedModel = GroupModel();
                            });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text("Update Group Category")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
