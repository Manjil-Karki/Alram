import 'package:alram/Database/models/brief_Alram_Model.dart';
import 'package:alram/screens/home_screen.dart';
import 'package:alram/screens/profile_screen.dart';
import 'package:alram/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:alram/screens/add_edit_alram.dart';

Route<dynamic> generateRoute(RouteSettings settings) {


  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Wrapper());
    case 'wrapper/home':
      return MaterialPageRoute(builder: (context) => HomePage());
    case 'wrapper/profile':
      return MaterialPageRoute(builder: (context) => Profile());
    case 'add_alram':
      BriefAlramModel? data = settings.arguments as BriefAlramModel;
      return MaterialPageRoute(builder: (context) => AddAlram(model: data));
    case 'setting':
      return MaterialPageRoute(builder: (context) => HomePage());
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
