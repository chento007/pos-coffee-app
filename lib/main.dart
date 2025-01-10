import 'package:coffee_app/app/routes/app_pages.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(
    ToastificationWrapper(
      child: GetMaterialApp(
        title: PROJECT_NAME,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
