import 'package:flutter/material.dart';
import 'package:register_form_app/pages/registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // ! Tab Controller
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.blue,

          // ! TabBarView - show tab's contents
          body: TabBarView(
            children: [
              RegistrationPage(),
              Container(),
            ],
          ),

          // ! BottomMenu - Tabs
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                text: 'Register',
              ),
              Tab(
                text: 'User list',
              )
            ],
          ),
        ));
  }
}
