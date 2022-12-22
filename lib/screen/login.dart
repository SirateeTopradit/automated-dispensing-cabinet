import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_application_1/model/profile.dart';
import 'package:flutter_application_1/screen/welcome.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(name: ' ',email: ' ', password: ' ');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "กรุณาป้อนอีเมลด้วยครับ"),
                                EmailValidator(
                                    errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                profile.email = email!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
                              obscureText: _isHidden,
                              onSaved: (String? password) {
                                profile.password = password!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text("ลงชื่อเข้าใช้",
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate) {
                                    formKey.currentState!.save();
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: profile.email,
                                              password: profile.password)
                                          .then((value) {
                                        formKey.currentState!.reset();
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  if(profile.email=="123456@gmail.com") return WelcomeScreen();
                                                  else return HomeScreen();
                                        }));
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      Fluttertoast.showToast(
                                          msg: "${e.message}",
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
