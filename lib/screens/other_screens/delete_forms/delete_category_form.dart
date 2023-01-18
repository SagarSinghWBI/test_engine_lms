// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_engine_lms/controllers/test_controller.dart';
// import 'package:test_engine_lms/models/GroupCategoryModel.dart';
// import 'package:test_engine_lms/utils/constants.dart';
// import 'package:test_engine_lms/utils/ui_widgets.dart';
//
// class DeleteCategoryScreen extends StatefulWidget {
//   const DeleteCategoryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DeleteCategoryScreen> createState() => _DeleteCategoryScreenState();
// }
//
// class _DeleteCategoryScreenState extends State<DeleteCategoryScreen> {
//   GroupCategoryModel? selectedModel;
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   List<GroupCategoryModel> groupCategories = [];
//
//   getAllCategories() async {
//     try {
//       groupCategories = await TestController().getAllCategories();
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
//               height: Get.height / 2.5,
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
//                                 "Delete Group Category",
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
//                               }),
//                           const SizedBox(height: 20),
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
//                           Icons.delete,
//                           size: 18,
//                           color: Colors.white,
//                         ),
//                         label: const Text("Delete Group Category")),
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
