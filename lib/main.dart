import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const OSNApp());
}

class OSNApp extends StatelessWidget {
  const OSNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Think Math',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
