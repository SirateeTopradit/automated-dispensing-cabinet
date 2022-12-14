import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:flutter_application_1/screen/welcome.dart';
import 'home.dart';

class emailVerify extends StatefulWidget {
  const emailVerify({super.key});

  @override
  State<emailVerify> createState() => _emailVerifyState();
}

class _emailVerifyState extends State<emailVerify> {
  bool _emailVerified = false;
  Timer? timer;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    
    _emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!_emailVerified) {
      sendver();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => check(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future check() async{
    await FirebaseAuth.instance.currentUser!.reload();

    setState((){
      _emailVerified = FirebaseAuth.instance.currentUser!.reload() as bool;
    });

    if(_emailVerified) timer?.cancel();
  }

  Future sendver() async{
    try{
      final user =FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    }catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _emailVerified ?  WelcomeScreen() : Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  auth.currentUser!.email!,
                  style: TextStyle(fontSize: 25),
                ),
                ElevatedButton(
                  child: Text("ส่งอีกครั้ง"),
                  onPressed: () => sendver(),
                ),
                TextButton(
                  child: Text("ยกเลิก"),
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}