import 'package:flutter/material.dart';
import 'package:web_api_3e/screens/current_location.dart';
import 'package:web_api_3e/screens/get_users.dart';
import 'package:web_api_3e/screens/maps_google.dart';
import 'package:web_api_3e/screens/register.dart';

void main() {
  runApp(const WebAPI());
}

class WebAPI extends StatelessWidget {
  const WebAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapsScreen(),
    );
  }
}
