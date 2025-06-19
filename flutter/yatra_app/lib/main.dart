import 'package:flutter/material.dart';
import 'package:yatra_app/app/app.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/core/network/hive_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  //init HIVE
  await HiveService().init();
  
  runApp(App());
}