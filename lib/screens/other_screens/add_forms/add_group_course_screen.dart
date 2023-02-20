import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class AddGroupCourseScreen extends StatefulWidget {
  const AddGroupCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupCourseScreen> createState() => _AddGroupCourseScreenState();
}

class _AddGroupCourseScreenState extends State<AddGroupCourseScreen> {
  TextEditingController courseName = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var dataController = Get.put(DataController());
  // GroupCategoryModel? selectedModel;

  // List<GroupCategoryModel> categoryList = [];
  //
  // getAllGroupCategories() async {
  //   try {
  //     categoryList = await TestController().getAllCategories();
  //     setState(() {});
  //     print("Category List:${categoryList.asMap()}");
  //   } catch (e) {
  //     print("Error is here:$e");
  //   }
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getAllGroupCategories();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    courseName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 2.3,
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
                            "Add Course Group",
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
                      // DropdownButtonFormField(
                      //     validator: (value) {
                      //       if (value == null) {
                      //         return "Please choose a Group Category!";
                      //       }
                      //       return null;
                      //     },
                      //     isDense: true,
                      //     decoration: getInputDecoration(
                      //         labelText: "Group Category", hintText: ""),
                      //     items: categoryList.map((e) {
                      //       return DropdownMenuItem<GroupCategoryModel>(
                      //         value: e,
                      //         child: Text(e.categoryName.toString()),
                      //       );
                      //     }).toList(),
                      //     onChanged: (value) {
                      //       selectedModel = value;
                      //       setState(() {});
                      //     }),
                      // const SizedBox(height: 20),

                      ///course field
                      TextFormField(
                        controller: courseName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is mandatory to fill.";
                          }
                          return null;
                        },
                        decoration: getInputDecoration(
                            labelText: "Group Name",
                            hintText:
                                "Ex:Management, Web Development, Communication, Economics etc."),
                      ),
                      const SizedBox(height: 20),
                      //
                      // ///course group description
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: TextFormField(
                      //     maxLines: 5,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return "This field is mandatory to fill.";
                      //       }
                      //       return null;
                      //     },
                      //     decoration: getInputDecoration(
                      //       labelText: "Group Description",
                      //       hintText:
                      //           "Ex: A course description is a brief summary of the significant learning experiences for a course.",
                      //       isMaxLines: true,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 15),
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
                            MaterialStatePropertyAll(Constants.primaryColor)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                        dataController.addGroup(
                            groupName: courseName.text,
                            onSuccess: () {
                              courseName.text = "";
                            });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text("Add this Group")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
