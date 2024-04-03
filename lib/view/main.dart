import 'package:flutter/material.dart';
import 'package:media_player/view/main_page.dart';
import 'package:permission_handler/permission_handler.dart';



void main() {
  _requestExternalStoragePermission();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}




Future<void> _requestExternalStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission is granted, you can now access external storage
    // Perform your file operations here
  } else {
    // Permission is not granted, handle it accordingly
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: main_page(),
    );
  }
}