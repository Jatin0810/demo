import 'package:demo_project/src/app.dart';
import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StorageManager.initializeSharedPreferences();
  runApp(const DemoApp());
}
