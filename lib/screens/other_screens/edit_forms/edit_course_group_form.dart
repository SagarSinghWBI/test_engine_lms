import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/test_controller.dart';
import 'package:test_engine_lms/models/GroupModel.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditGroupCourseScreen extends StatefulWidget {
  const EditGroupCourseScreen({Key? key}) : super(key: key);

  @override
  State<EditGroupCourseScreen> createState() => _EditGroupCourseScreenState();
}

class _EditGroupCourseScreenState extends State<EditGroupCourseScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GroupModel? selectedModel;
  List<GroupModel> coursesList = [];

  ///controllers
  TextEditingController courseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  getAllGroupCategories() async {
    try {
      coursesList = await TestController().getAllCourses();
      setState(() {});
      print("Category List:${coursesList.asMap()}");
    } catch (e) {
      print("Error is here:$e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGroupCategories();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    courseNameController.dispose();
    descriptionController.dispose();
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
                            "Edit Course Group",
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
                                labelText: "Select Course Group", hintText: ""),
                            items: coursesList.map((e) {
                              return DropdownMenuItem<GroupModel>(
                                value: e,
                                child: Text(e.courseName.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedModel = value;
                              setState(() {});
                              courseNameController.text=selectedModel!.courseName!;
                              descriptionController.text=selectedModel!.description!;

                            }),
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
                              labelText: "New Course Group Name",
                              hintText:
                                  "Ex: Web Development, Communication, Economics etc."),
                        ),
                        const SizedBox(height: 20),

                        ///course group description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field is mandatory to fill.";
                              }
                              return null;
                            },
                            decoration: getInputDecoration(
                              labelText: "New Group Description",
                              hintText:
                                  "Ex: A course description is a brief summary of the significant learning experiences for a course.",
                              isMaxLines: true,
                            ),
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
