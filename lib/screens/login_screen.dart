import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/screens/other_screens/edit_forms/forget_password_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
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
                Text("~~~ Welcome To WBI Test Maker ~~~",
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
                                      } else if (!(GetUtils.isEmail(
                                          value.trim()))) {
                                        return "Please enter a valid email.";
                                      }
                                      return null;
                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Email",
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
                                    obscureText: true,
                                    onFieldSubmitted: (value) {
                                      if (loginFormKey.currentState!
                                          .validate()) {
                                        AuthController().loginUser(
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim());
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
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
                                                    email: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim());
                                              }
                                            },
                                            label:
                                                const Text("Login as Admin")),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Constants.primaryColor),
                                            ),
                                            icon: const Icon(
                                                Icons.account_circle),
                                            onPressed: () async {
                                              await launchUrl(Uri.parse(
                                                  Constants
                                                      .buySubscriptionURL));
                                            },
                                            label: const Text(
                                                "Create New Account")),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Get.dialog(
                                                const ForgetPasswordScreen());
                                          },
                                          child: const Text(
                                            "forget password?",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    ],
                                  ),
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
