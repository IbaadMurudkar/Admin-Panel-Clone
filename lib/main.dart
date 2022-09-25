import 'package:admin_panel/controllers/menu_controller.dart';
import 'package:admin_panel/provider/dark_theme_provider.dart';
import 'package:admin_panel/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCz0WkCRhWpM3vCBWPcl8BHApc-byofXoE",
      appId: "1:1056131911807:web:c21a9a10b6723576f5ef4a",
      messagingSenderId: "G-JNY8P592XD",
      projectId: "e-commerce-app-4fc3f",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('App is being initialized'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has been occured ${snapshot.error}'),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) {
                return MenuController();
              })
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
              );
            }),
          );
        });
  }
}
