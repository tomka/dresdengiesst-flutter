import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'src/web_view_stack.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Delay splash screen for half a second
  await Future.delayed(const Duration(milliseconds: 500));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dresden gießt',
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
      debugShowCheckedModeBanner: false
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://app.dresdengiesst.de'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
            title: Text("Dresden gießt", style: TextStyle(fontSize: 15)),
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 30.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 0.00,
            backgroundColor: Colors.white,
            //foregroundColor: Colors.white,
          ),
      body: SafeArea(
        child: WebViewStack(controller: controller),
      )
    );
  }
}
