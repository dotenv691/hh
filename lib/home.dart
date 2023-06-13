// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int steps = 0;
  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() async {
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.STEPS];
    DateTime midnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List<HealthDataAccess> permissions = [HealthDataAccess.READ];
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      try {
        await health.requestAuthorization(types, permissions: permissions);
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          initialData();
        });
        steps = await health.getTotalStepsInInterval(midnight, DateTime.now()) ?? 0;
        setStates();
      } catch (err) {
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

  void setStates() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: Text('Total step is $steps')),
      ),
    );
  }
}
