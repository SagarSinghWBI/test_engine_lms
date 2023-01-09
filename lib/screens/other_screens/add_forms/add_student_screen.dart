import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
                            "Add a Student",
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
                        TextFormField(
                          controller: userNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "UserName",
                            hintText: "Ex: developer@123",
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is mandatory to fill.";
                            } else if (value.length < 7) {
                              return "Password must be more than 7 digits.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Password",
                            hintText: "Ex: Password@#%7",
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is mandatory to fill.";
                            } else if (value.trim() !=
                                passwordController.text.trim()) {
                              return "Confirm password doesn't match.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Ex: Password@#%7",
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: studentNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "Student Name",
                              hintText: "Ex: Sagar Singh"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: mobileController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "Mobile", hintText: "Ex: 9876543210"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is mandatory to fill.";
                            } else if (!(GetUtils.isEmail(value.trim()))) {
                              return "Please enter a valid email address.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "Email",
                              hintText: "Ex: email123@gmail.com"),
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
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text("Add Student")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
