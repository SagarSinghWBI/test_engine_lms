import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/controllers/dataController.dart';
import 'package:test_engine_lms/utils/constants.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({Key? key}) : super(key: key);

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var dataController = Get.put(DataController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contentController.dispose();
  }

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
              height: Get.height / 2.2,
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
                                "Add a Notice",
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
                          TextFormField(
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field is mandatory to fill.";
                              }
                              return null;
                            },
                            controller: contentController,
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Constants.primaryColor),
                                hintStyle: const TextStyle(fontSize: 15),
                                labelText: "Notice",
                                hintText:
                                    "Ex: New tests are published in the IT Category.",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Constants.primaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                            dataController.addNotice(
                                content: contentController.text,
                                onSuccess: () {
                                  contentController.text = "";
                                });
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text("Add Notice")),
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
