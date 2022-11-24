import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/screens/product_list/product_list_view.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // status bar color
      statusBarBrightness: Brightness.dark, //status bar brightness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.palette1,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 1.5,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: ProductListView(),
    );
  }
}

class Palette {
  static const MaterialColor palette1 = MaterialColor(
    _palette1PrimaryValue,
    <int, Color>{
      50: Color(0xFFE1E5E4),
      100: Color(0xFFB3BEBC),
      200: Color(0xFF81928F),
      300: Color(0xFF4E6662),
      400: Color(0xFF284641),
      500: Color(_palette1PrimaryValue),
      600: Color(0xFF02211B),
      700: Color(0xFF011B17),
      800: Color(0xFF011612),
      900: Color(0xFF010D0A),
    },
  );
  static const int _palette1PrimaryValue = 0xFF02251F;
}
