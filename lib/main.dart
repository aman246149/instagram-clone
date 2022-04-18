import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Providers/user_provider.dart';
import 'package:instagram_clone/Screens/Login_Screen.dart';
import 'package:instagram_clone/reponsive/Mobile_Screen_Layout.dart';
import 'package:instagram_clone/reponsive/Web_Screen_Layout.dart';
import 'package:instagram_clone/reponsive/reponsive_layout_screen.dart';
import 'package:provider/provider.dart';
import './utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBMvhlg78Sv7bVBfAtRl-Go7IHA2wOwX0M",
            appId: "1:953933294055:web:b8b28a960ab091a0d3b542",
            messagingSenderId: "953933294055",
            projectId: "instagram-9644f",
            storageBucket: "instagram-9644f.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const Login_Screen(),
        // home: ResponsiveLayout(
        //   DeskTopScreen: DesktopScreenLayout(),
        //   MobileScreen: MobileScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                  DeskTopScreen: DesktopScreenLayout(),
                  MobileScreen: const MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
            }

            return const Login_Screen();
          },
        ),
      ),
    );
  }
}
