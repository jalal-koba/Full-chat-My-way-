import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_way_chat/Chat/View/Screens/chats_screen.dart';
import 'package:my_way_chat/Chat/temp/network.dart';
import 'package:sizer/sizer.dart';

// this project designed to merge with "My way" The Best Syrian educational platform

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Network.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xFF2BA9A6)));
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: ChatsScreens(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
