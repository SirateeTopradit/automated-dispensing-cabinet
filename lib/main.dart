import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:flutter_application_1/screen/welcome.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screen/emailVerify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'authentication_provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  @override
  
  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          //color set to transperent or set your own color
          statusBarIconBrightness: Brightness.dark, 
          //set brightness for icons, like dark background light icons
      )
    );
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState, initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Firebase Authentication',
        theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        fontFamily: 'prompt',
        primarySwatch: Colors.blue,
        
      ),
        home: Authenticate(),
      ),
    );
  }
}


class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return WelcomeScreen();
    }
    return  HomeScreen();
  }
}