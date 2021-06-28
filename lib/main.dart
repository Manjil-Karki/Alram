import 'package:flutter/material.dart';
import 'package:alram/screens/wrapper.dart';
import 'package:alram/utilities/router.dart' as router;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( 
        primarySwatch: Colors.lime,
        accentColor: Colors.orange,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
      home: Wrapper(),
    );
  }
}
