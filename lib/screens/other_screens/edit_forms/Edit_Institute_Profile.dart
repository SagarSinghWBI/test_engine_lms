import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_engine_lms/controllers/auth_controller.dart';
import 'package:test_engine_lms/screens/homepage_screen.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/image_picking_service.dart';
import 'package:test_engine_lms/utils/ui_widgets.dart';

class EditInstituteProfile extends StatefulWidget {
  EditInstituteProfile(
      {Key? key,
      required this.userImage,
      required this.userName,
      required this.phoneNumber})
      : super(key: key);

  String userName;
  String userImage;
  String phoneNumber;

  @override
  State<EditInstituteProfile> createState() => _EditInstituteProfileState();
}

class _EditInstituteProfileState extends State<EditInstituteProfile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController instituteNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  FilePickerResult? instituteImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumberController.text = widget.phoneNumber;
    instituteNameController.text = widget.userName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    instituteNameController.dispose();
    phoneNumberController.dispose();
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
                            "Edit Profile",
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        ///institute image
                        InkWell(
                          onTap: () async {
                            await ImagePickingService().pickImageFromGallery(
                                onSelected:
                                    (FilePickerResult filePickerResult) async {
                              setState(() {
                                instituteImage = filePickerResult;
                              });
                            });
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.indigo),
                                    color: Colors.white,
                                    image: instituteImage == null
                                        ? const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "lib/assets/campus_image.png"),
                                          )
                                        : DecorationImage(
                                            fit: BoxFit.fill,
                                            image: MemoryImage(instituteImage!
                                                .files.single.bytes!),
                                          ),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.primaryColor,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        ///institute name field
                        TextFormField(
                          controller: instituteNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "New Institute Name", hintText: ""),
                        ),
                        const SizedBox(height: 20),

                        ///phone number field
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          // initialValue: widget.phoneNumber,
                          controller: phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is mandatory to fill.";
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              labelText: "New Phone Number", hintText: ""),
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
                          MaterialStatePropertyAll(Constants.primaryColor),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///hit api here
                        AuthController().updateInstitute(
                            userName: instituteNameController.text,
                            mobile: phoneNumberController.text,
                            instituteImage: instituteImage,
                            onSuccess: () async {
                              await AuthController().getUserById();
                            });
                        // print("Questions List:${questionsList.asMap()}");
                        // print("1:${questionsList[0].toJson()}");
                        // print("2:${questionsList[1].toJson()}");
                        // print("3:${questionsList[2].toJson()}");
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text("Update Profile")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
