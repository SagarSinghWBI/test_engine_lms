import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isEmailSent = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 1.5,
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
                            "Forget Password",
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
                        width: Get.width / 3,
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
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email.";
                              } else if (!(GetUtils.isEmail(value.trim()))) {
                                return "Please enter a valid email address.";
                              }
                              return null;
                            },
                            decoration: getInputDecoration(
                                labelText: "Email",
                                hintText: "Ex:- sagarsingh@gmail.com"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: newPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your new password.";
                              }
                              return null;
                            },
                            decoration: getInputDecoration(
                              labelText: "New Password",
                              hintText: "Ex:- sagarsingh@gmail.com",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onFieldSubmitted: (value) {
                              onSubmit.call();
                            },
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Confirm your new password.";
                              }
                              return null;
                            },
                            decoration: getInputDecoration(
                              labelText: "New Password",
                              hintText: "Ex:- sagarsingh@gmail.com",
                            ),
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: isEmailSent,
                            child: Column(
                              children: [
                                const Text(
                                    "Enter the OTP that sent to your Email.",
                                    style: TextStyle(color: Colors.green)),
                                const SizedBox(height: 10),
                                OTPTextField(
                                  length: 6,
                                  width: MediaQuery.of(context).size.width / 2,
                                  fieldWidth: 80,
                                  style: const TextStyle(fontSize: 17),
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  otpFieldStyle: OtpFieldStyle(
                                    enabledBorderColor: Constants.primaryColor,
                                  ),
                                  isDense: true,
                                  onCompleted: (pin) {
                                    otpController.text = pin;
                                    if (kDebugMode) {
                                      print("Completed: $pin");
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          ///send otp on user email.
                                          AuthController().sendEmailOTP(
                                            onSuccess: () {
                                              setState(() {
                                                isEmailSent = true;
                                              });
                                            },
                                            email: emailController.text,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Resend OTP?",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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
                          MaterialStatePropertyAll(Constants.primaryColor),
                    ),
                    onPressed: () {
                      onSubmit.call();
                    },
                    icon: Icon(
                      isEmailSent ? Icons.edit : Icons.password,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: isEmailSent
                        ? const Text("Update Password")
                        : const Text("Send OTP")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      if (isEmailSent) {
        ///verify otp here
        AuthController().verifyOTP(
          onSuccess: () {
            ///reset password here
            AuthController().resetInstitutePassword(
              onSuccess: () {
                formKey.currentState?.reset();
                emailController.text = "";
                newPasswordController.text = "";
                otpController.text = "";
                setState(() {
                  isEmailSent = false;
                });
                getSuccessDialogue(
                    message:
                        "Password changed Successfully.\nPlease login to continue.");
              },
              email: emailController.text,
              newPassword: newPasswordController.text,
            );
          },
          email: emailController.text,
          OTP: otpController.text,
        );
      } else {
        ///sending email and then set the state for email sent
        AuthController().sendEmailOTP(
          onSuccess: () {
            setState(() {
              isEmailSent = true;
            });
          },
          email: emailController.text,
        );
      }
    }
  }
}
