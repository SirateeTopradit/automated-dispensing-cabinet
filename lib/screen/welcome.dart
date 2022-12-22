import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'home.dart';

class Language {
  final int id;
  final String name;

  Language({
    required this.id,
    required this.name,
  });
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(name: ' ', email: ' ', password: ' ');
  final auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _codeCollection =
      FirebaseFirestore.instance.collection("Code");

  List<String> med = ["0", "0", "0", "0", "0"];
  String med2 = " ";
  int _selectedIndex = 1;
  static List<Language> _languages = [
    Language(id: 1, name: "Antacill"),
    Language(id: 2, name: "Noxzy"),
    Language(id: 3, name: "Paracetamol"),
    Language(id: 4, name: "Chlorpheniramine"),
    Language(id: 5, name: "Plaster"),
  ];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 1;
  final _items = _languages
      .map((language) => MultiSelectItem<Language>(language, language.name))
      .toList();

  List<Language> _selectedLanguages = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Code").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          child: FittedBox(
                            child: Text(
                              "  " + document["code"] + "  ",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                              ),
                          ),
                        ),
                        title: Text("รายการ"),
                        subtitle: Text(
                          document["list"]+"\n"+(document["flag"]=="1" ? " Avaliable":" Not avaliable"),
                        ),

                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => setState(() {
                            _codeCollection.doc(document.id).delete();
                          }),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        );
      case 1:
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                //################################################################################################
                // Rounded blue MultiSelectDialogField
                //################################################################################################
                MultiSelectDialogField(
                  items: _items,
                  listType: MultiSelectListType.CHIP,
                  selectedItemsTextStyle: TextStyle(color: Colors.black),
                  searchable: true,
                  // chipDisplay: MultiSelectChipDisplay.none(),
                  title: Text("ค้นหา"),
                  selectedColor: Color.fromARGB(255, 119, 119, 119),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.medical_services,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  buttonText: Text(
                    "เลือกยา",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    med = ["0", "0", "0", "0", "0"];
                    med2 = " ";
                    _selectedLanguages = results;
                    print(_selectedLanguages);
                    _selectedLanguages.forEach((language) {
                      print('-----');
                      print(language.id);
                      switch (language.id) {
                        case 1:
                          med[0] = "1";
                          med2 += language.name + " ";
                          break;
                        case 2:
                          med[1] = "1";
                          med2 += language.name + " ";
                          break;
                        case 3:
                          med[2] = "1";
                          med2 += language.name + " ";
                          break;
                        case 4:
                          med[3] = "1";
                          med2 += language.name + " ";
                          break;
                        case 5:
                          med[4] = "1";
                          med2 += language.name + " ";
                          break;
                      }
                    });
                    print(med);
                  },
                ),
                SizedBox(height: 20),
                Form(
                    key: formKey,
                    child: Column(children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'ชื่อนักเรียน',
                          border: OutlineInputBorder(),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณาป้อนชื่อด้วยครับ"),
                        ]),
                        onSaved: (String? name) {
                          profile.name = name!;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: Text("ตกลง"),
                        onPressed: () async {
                          if (formKey.currentState!.validate) {
                            formKey.currentState!.save();
                            var rng = Random();
                            String code =
                                (rng.nextInt(900000) + 100000).toString();
                            print(code);
                            String datetime = DateTime.now().toString();
                            _showMyDialog();
                            await _codeCollection.add({
                              "med1": med[0],
                              "med2": med[1],
                              "med3": med[2],
                              "med4": med[3],
                              "med5": med[4],
                              "code": code,
                              "io": med.join(""),
                              "name": profile.name,
                              "list": med2,
                              "time": datetime,
                              "flag": "1",
                            });
                            med = ["0", "0", "0", "0", "0"];
                            formKey.currentState!.reset();
                          }
                        },
                      ),
                    ])),
              ],
            ),
          ),
        );
      case 2:
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Code").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: ListTile(
                        title: Text(document["name"]),
                        subtitle: Text(
                          document["list"]+"\n "+document["time"],
                        ),
                        
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => setState(() {
                            _codeCollection.doc(document.id).delete();
                          }),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        );

      default:
        return Text("Error");
    }
  }

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
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  centerTitle: false,
                  title: Text(
                    'Medic care',
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return HomeScreen();
                          }));
                        });
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  child: CurvedNavigationBar(
                    key: _bottomNavigationKey,
                    index: 1,
                    height: 60.0,
                    items: <Widget>[
                      Icon(Icons.list, size: 30),
                      Icon(Icons.add, size: 30),
                      Icon(Icons.perm_identity, size: 30),
                    ],
                    color: Color.fromARGB(255, 0, 0, 0),
                    buttonBackgroundColor: Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: Colors.white,
                    animationCurve: Curves.easeInOut,
                    animationDuration: Duration(milliseconds: 400),
                    onTap: (index) {
                      setState(() {
                        _page = index;
                      });
                    },
                    letIndexChange: (index) => true,
                  ),
                ),
                body: _getDrawerItemWidget(_page),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('เลือกยาเสร็จสิ้น'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
