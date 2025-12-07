import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/dioHelper/dio_helper.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/settings/settings_view.dart';
import 'package:qrscanner/firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HttpOverrides.global = MyHttpOverrides();

  await AppStorage.init();
  DioHelper.initBaseUrl();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('app_control')
          .doc('status')
          .snapshots(),
      builder: (context, snapshot) {
        // حالة الانتظار للبيانات
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
            debugShowCheckedModeBanner: false,
          );
        }

        // حالة وجود خطأ
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'حدث خطأ أثناء الاتصال بالخادم.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        // حالة البيانات موجودة
        final bool isAppEnabled = snapshot.data?.get('enabled') ?? false;
        if (!isAppEnabled) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'التطبيق لا يعمل حالياُ الرجاء التواصل مع المطور',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        // التطبيق يعمل
        return MaterialApp(
          home: const SettingsView(),
          onGenerateRoute: onGenerateRoute,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(fontFamily: 'Tajwal', primaryColor: colorPrimary),
        );
      },
    );
  }
}
