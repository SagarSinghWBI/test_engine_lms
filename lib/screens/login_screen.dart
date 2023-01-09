import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/screens/homepage_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "lib/assets/background_electrons.jpg",
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          Container(
            height: Get.height,
            width: Get.width,
            margin: const EdgeInsets.all(100),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text("~~~ Welcome To LMS ~~~",
                    style: TextStyle(
                        fontSize: 25,
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Row(
                    children: [
                      ///image vector
                      Expanded(
                        child: Image.asset(
                          "lib/assets/test_man_vector.png",
                          // width: Get.width / 3,
                        ),
                      ),

                      ///login form
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Form(
                              key: loginFormKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: Image.asset(
                                      "lib/assets/man_login_vector.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your username";
                                      }
                                      return null;
                                    },
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Username",
                                        labelStyle: TextStyle(
                                            color: Constants.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Constants.primaryColor,
                                              width: 2.0),
                                        )),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    onFieldSubmitted: (value){
                                      if (loginFormKey.currentState!
                                          .validate()) {
                                        AuthController().loginUser(
                                            username: usernameController
                                                .text
                                                .trim(),
                                            password: passwordController
                                                .text
                                                .trim());
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Constants.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Constants.primaryColor,
                                              width: 2.0),
                                        )),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                      height: 30,
                                      width: 250,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Constants.primaryColor),
                                            ),
                                            icon: const Icon(Icons.login),
                                            onPressed: () {
                                              if (loginFormKey.currentState!
                                                  .validate()) {
                                                AuthController().loginUser(
                                                    username: usernameController
                                                        .text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim());
                                              }
                                            },
                                            label:
                                                const Text("Login as Admin")),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
