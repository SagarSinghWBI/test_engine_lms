import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:test_engine_lms/models/GetPerformanceModel.dart';
import 'package:test_engine_lms/models/GetStudentsModel.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/responsive.dart';

class ShowPerformanceScreen extends StatefulWidget {
  const ShowPerformanceScreen({Key? key, required this.studentModel})
      : super(key: key);

  final GetStudentsModel studentModel;

  @override
  State<ShowPerformanceScreen> createState() => _ShowPerformanceScreenState();
}

class _ShowPerformanceScreenState extends State<ShowPerformanceScreen> {
  Future<GetPerformanceModel> getStudentCurrentPerformance(
      {required int userId}) async {
    GetPerformanceModel model = GetPerformanceModel();
    try {
      await dio_package.Dio()
          .get("${Constants.baseUrl}/calculateStudentPerformance/$userId")
          .then((value) {
        if (value.statusCode == 200) {
          model = GetPerformanceModel(
            percentage: value.data["percentage"],
            finalComment: value.data["finalComment"],
            studentGrade: value.data["studentGrade"],
            studentId: value.data["studentId"],
            studentName: value.data["studentName"],
            totalHoursSpent: value.data["totalHoursSpent"],
            totalTests: value.data["totalTests"],
            totalTestTaken: value.data["totalTestTaken"],
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while getting student performance:$e");
      }
    }

    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.secondaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.studentModel.userName} Performance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer()
                  // Text('Performance'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: FutureBuilder(
                future: getStudentCurrentPerformance(
                    userId: widget.studentModel.studentId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    GetPerformanceModel performanceModel =
                        snapshot.data as GetPerformanceModel;
                    if (kDebugMode) {
                      print('performance model:${performanceModel.percentage}');
                    }

                    if (performanceModel.percentage == null) {
                      return Center(child: Image.asset("lib/assets/nodata.png"));
                    } else {
                      return Responsive.isMobile(context) ||
                              Responsive.isTablet(context)
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getPerformanceElements(
                                    studentPerformanceModel: performanceModel),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: getPerformanceElements(
                                  studentPerformanceModel: performanceModel),
                            );
                    }
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPerformanceElements(
      {required GetPerformanceModel studentPerformanceModel}) {
    return [
      SizedBox(
        height: Get.height / 1.3,
        width: Responsive.isTablet(context) || Responsive.isMobile(context)
            ? Get.width
            : Get.width / 2.8,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                height: 100,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${studentPerformanceModel.studentName.toString()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'UID: ${studentPerformanceModel.studentId.toString()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade Status: ${studentPerformanceModel.studentGrade.toString()}',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Hours Spent: ${studentPerformanceModel.totalHoursSpent.toString()}',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Total Tests Taken: ${studentPerformanceModel.totalTestTaken.toString()}',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Final Comment: ${studentPerformanceModel.finalComment.toString()}',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Responsive.isDesktop(context)
          ? const SizedBox(
              width: 15,
            )
          : const SizedBox(
              height: 15,
            ),
      SizedBox(
        width: Responsive.isTablet(context) || Responsive.isMobile(context)
            ? Get.width
            : Get.width / 2.8,
        height: Get.height / 1.3,
        child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SfRadialGauge(enableLoadingAnimation: true, axes: <
                      RadialAxis>[
                    RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0, endValue: 35, color: Colors.red),
                      GaugeRange(
                          startValue: 35, endValue: 70, color: Colors.orange),
                      GaugeRange(
                          startValue: 70, endValue: 100, color: Colors.green)
                    ], pointers: <GaugePointer>[
                      NeedlePointer(
                          value: studentPerformanceModel.percentage!.toDouble())
                    ], annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                            '${studentPerformanceModel.percentage!.toDouble()}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ])
                  ]),
                  Text(
                    'Performance Meter',
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                      'Percentage: ${studentPerformanceModel.percentage.toString()}'),
                ],
              ),
            )),
      ),
    ];
  }
}
