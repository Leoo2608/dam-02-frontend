import 'package:flutter/material.dart';
import 'package:frontend_flutter/pages/home_page.dart';
import 'package:frontend_flutter/pages/login_page.dart';
import 'package:frontend_flutter/pages/posts_page.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/services/posts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

setupLocator() {
  GetIt.I.registerLazySingleton(() => PostsService());
}
String? initScreen = 'empty';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getString('token');
  print('token ${initScreen}');
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initScreen == 'empty' || initScreen == null ? 'login_page' : 'home_page',
      routes: {
        PostsPage.id: (context) => PostsPage(),
        HomePage.id: (context) => HomePage(),
        LoginPage.id: (context) => LoginPage()
      },
    );
  }
}
