import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:robolearn/view/class_page.dart';
import 'package:robolearn/view/componentdetail_page.dart';
import 'package:robolearn/view/config_page.dart';
import 'package:robolearn/view/dictionary_page.dart';
import 'package:robolearn/view/editprofile_page.dart';
import 'package:robolearn/view/exercise_page.dart';
import 'package:robolearn/view/login_page.dart';
import 'package:robolearn/view/profile_page.dart';
import 'package:robolearn/view/register_page.dart';
import 'package:robolearn/view/home_page.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const RoboLearnApp());
}

class RoboLearnApp extends StatelessWidget {
  const RoboLearnApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoboLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Georgia'),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/dictionary': (context) => DictionaryPage(),
        //'/component': (context) => ComponentDetailPage(),
        '/class': (context) => ClassPage(moduleType: '',),
        '/exercise': (context) => ActivityPage(),        
        '/profile': (context) => ProfilePage(),
        '/config': (context) => ConfigPage(),
        '/edit_profile': (context) => EditProfilePage()
      },
    );
  }
}
