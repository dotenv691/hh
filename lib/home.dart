// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HealthFactory health = HealthFactory();
  int steps = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitialData();
  }

  void InitialData() async {
    var types = [HealthDataType.STEPS];
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);
    var permissions = [HealthDataAccess.READ];
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      try {
        types = [HealthDataType.STEPS];
        await health.requestAuthorization(types, permissions: permissions);
        print('Work try');
        steps = await health.getTotalStepsInInterval(midnight, now) ?? 0;

        print('steps ::: $steps');
      } catch (err) {
        print('Work catch');
        print('Caught exception in getTotalStepsInInterval: $err');
      }
    }

    // // Сүүлийн 24 цагийн дата татах
    // List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(now.subtract(const Duration(days: 1)), now, types);

    // // request permissions to write steps and blood glucose

    // // write steps and blood glucose
    // bool success = await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    // success = await health.writeHealthData(3.1, HealthDataType.BLOOD_GLUCOSE, now, now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Text('Total step is $steps'),
      ),
    );
  }
}
