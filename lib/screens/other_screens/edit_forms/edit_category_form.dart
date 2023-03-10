// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_engine_lms/controllers/test_controller.dart';
// import 'package:test_engine_lms/models/GroupCategoryModel.dart';
// import 'package:test_engine_lms/utils/constants.dart';
// import 'package:test_engine_lms/utils/ui_widgets.dart';
//
// class EditCategoryScreen extends StatefulWidget {
//   const EditCategoryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditCategoryScreen> createState() => _EditCategoryScreenState();
// }
//
// class _EditCategoryScreenState extends State<EditCategoryScreen> {
//   GroupCategoryModel? selectedModel;
//   TextEditingController categoryName = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   List<GroupCategoryModel> groupCategories = [];
//
//   getAllCategories() async {
//     try {
//       groupCategories = await TestController().getAllCategories();
//
//       setState(() {});
//     } catch (e) {
//       print("Error:$e");
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getAllCategories();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     categoryName.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               height: Get.height / 2,
//               width: Get.width / 1.6,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(20)),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Column(
//                         // crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 "Edit Group Category",
//                                 style: TextStyle(
//                                   color: Constants.primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               )),
//                           const SizedBox(height: 5),
//                           Container(
//                             alignment: Alignment.centerLeft,
//                             height: 5,
//                             width: 400,
//                             decoration: BoxDecoration(
//                               color: Colors.indigo,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       IconButton(
//                           tooltip: "Cancel",
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: const Icon(
//                             Icons.cancel,
//                             color: Colors.red,
//                           )),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           DropdownButtonFormField(
//                               validator: (value) {
//                                 if (value == null) {
//                                   return "Please choose a Category!";
//                                 }
//                                 return null;
//                               },
//                               isDense: true,
//                               decoration: getInputDecoration(
//                                 labelText: "Select Group Category",
//                                 hintText: "",
//                               ),
//                               items: groupCategories.map((e) {
//                                 return DropdownMenuItem<GroupCategoryModel>(
//                                   value: e,
//                                   child: Text(e.categoryName.toString()),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 selectedModel = value;
//                                 setState(() {});
//                                 categoryName.text =
//                                     selectedModel!.categoryName!;
//                               }),
//                           const SizedBox(height: 15),
//                           TextFormField(
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "This field is mandatory to fill.";
//                               }
//                               return null;
//                             },
//                             controller: categoryName,
//                             decoration: InputDecoration(
//                                 labelStyle:
//                                     TextStyle(color: Constants.primaryColor),
//                                 hintStyle: const TextStyle(fontSize: 15),
//                                 labelText: "New Group Category Name",
//                                 hintText:
//                                     "Ex: Development, Business, IT & Software, Designing etc.",
//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                     borderSide: BorderSide(
//                                         color: Constants.primaryColor)),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                 )),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                     width: Get.width,
//                     child: ElevatedButton.icon(
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 Constants.primaryColor)),
//                         onPressed: () {
//                           if (formKey.currentState!.validate()) {
//                             ///hit api here
//                           }
//                         },
//                         icon: const Icon(
//                           Icons.edit,
//                           size: 18,
//                           color: Colors.white,
//                         ),
//                         label: const Text("Update Group Category")),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
