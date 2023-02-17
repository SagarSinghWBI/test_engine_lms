import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_engine_lms/models/HelpQuestionsModel.dart';
import 'package:test_engine_lms/utils/constants.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  List<HelpQuestionsModel> questions = [
    HelpQuestionsModel(
      question: "Can we give a exam or text again and again?",
      answer: "No, You can't.",
    ),
    HelpQuestionsModel(
      question: "How the performance is created?",
      answer:
          "Performance is created on the basis of test results and Software Usage.",
    ),
    HelpQuestionsModel(
      question: "How to contact Administrator?",
      answer:
          "You can contact Administrator through Email: sagar.webbullindia@gmail.com",
    ),
    HelpQuestionsModel(
      question: "How to update our profile?",
      answer:
          "User can update their username or user image from the left drawer.",
    ),
    HelpQuestionsModel(
      question: "I am unable to login to app or website.",
      answer:
          "Please contact our administrator through email: sagar.webbullindia@gmail.com",
    ),
  ];

  List<HelpQuestionsModel> filteredQuestionsList = [
    HelpQuestionsModel(
      question: "Can we give a exam or text again and again?",
      answer: "No, You can't.",
    ),
    HelpQuestionsModel(
      question: "How the performance is created?",
      answer:
          "Performance is created on the basis of test results and Software Usage.",
    ),
    HelpQuestionsModel(
      question: "How to contact Administrator?",
      answer:
          "You can contact Administrator through Email: sagar.webbullindia@gmail.com",
    ),
    HelpQuestionsModel(
      question: "How to update our profile?",
      answer:
          "User can update their username or user image from the left drawer.",
    ),
    HelpQuestionsModel(
      question: "I am unable to login to app or website.",
      answer:
          "Please contact our administrator through email: sagar.webbullindia@gmail.com",
    ),
  ];

  setData({required String searchString}) {
    if (searchString == "") {
      filteredQuestionsList = questions;
    } else {
      filteredQuestionsList.clear();

      for (var element in questions) {
        if (element
            .toJson()
            .toString()
            .toLowerCase()
            .contains(searchString.toLowerCase())) {
          filteredQuestionsList.add(element);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Help & Support",
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
              const SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  if (value.toString() != "") {
                    setData(searchString: value);
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    isDense: false,
                    labelStyle: TextStyle(color: Constants.primaryColor),
                    hintStyle: const TextStyle(fontSize: 15),
                    labelText: "Search for Questions",
                    hintText: "Ex: How to upgrade Subscription?",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Constants.primaryColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                itemCount: filteredQuestionsList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 5, top: 10),
                    width: Get.width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constants.primaryColor,
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.grey,
                      //     blurRadius: 2,
                      //     spreadRadius: 2,
                      //   ),
                      // ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question: ${filteredQuestionsList[index].question}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Constants.headerColor),
                          ),
                          const SizedBox(height: 5),
                          Text("Answer: ${filteredQuestionsList[index].answer}",
                              style: TextStyle(color: Constants.dataColor)),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
