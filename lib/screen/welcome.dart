import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  static List<Language> _languages = [
    Language(id: 1, name: "ยา1"),
    Language(id: 2, name: "ยา222222222222"),
    Language(id: 3, name: "ยา3333333333333333"),
    Language(id: 4, name: "ยา444444444444444444"),
    Language(id: 5, name: "ยา555555555"),
  ];
  final _items = _languages
      .map((language) => MultiSelectItem<Language>(language, language.name))
      .toList();

  List<Language> _selectedLanguages = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
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
                  _selectedLanguages = results;
                  print(_selectedLanguages);
                  _selectedLanguages.forEach((language) {
                    print('-----');
                    print(language.name);
                  });
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}