import 'package:flutter/material.dart';

const kPrimary = Color(0xFF1E6FEB);
const kBg = Color(0xFFF4F7FB);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
