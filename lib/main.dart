import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'src/web_view_stack.dart';
import 'src/common.dart';

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
      title: 'DRESDEN GIESST',
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
  final homeUrl = Uri.parse('https://app.dresdengiesst.de');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(homeUrl);

    final platformController = controller.platform;
    if (platformController is AndroidWebViewController) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        platformController.setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            // request location permission
            final locationPermissionStatus = await Permission.locationWhenInUse
                .request();

            // return the response
            return GeolocationPermissionsResponse(
              allow: locationPermissionStatus == PermissionStatus.granted,
              retain: false,
            );
          },
        );
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
            title: Text("DRESDEN GIESST", style: TextStyle(fontSize: 15)),
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
            leading: Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: IconButton(
                icon: const Icon(Icons.home),
                color: Colors.grey,
                iconSize: 18,
                onPressed: () => controller.loadRequest(homeUrl),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Colors.grey,
                  iconSize: 18,
                  onPressed: () => launchURL(
                    Uri.parse("https://github.com/dresdengiesst/dresdengiesst-flutter")
                  ),
                ),
              ),
            ],
          ),
      body: SafeArea(
        child: WebViewStack(controller: controller),
      )
    );
  }
}
