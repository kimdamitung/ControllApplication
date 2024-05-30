import 'package:flutter/material.dart';
import 'package:AppController/screens/open_page.dart';
import 'package:AppController/screens/search_ip.dart';
import 'package:AppController/screens/scan_ip.dart';
import 'package:AppController/screens/home_page.dart';

void main() {
  runApp(const MainWindow());
}

class MainWindow extends StatelessWidget {
  const MainWindow({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "AppController",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/openpage": (context) => const OpenPage(),
        "/searchip": (context) => const SearchIp(),
        "/scanip": (context) => const ScanIp(),
        "/homepage": (context) => const HomePage(),
      },
      initialRoute: "/homepage",
    );
  }
}
