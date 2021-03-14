import 'package:flutter/material.dart';
import 'package:register_form_app/pages/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';

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
  // ! Field variables
  final Future<FirebaseApp> _initializztion = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializztion,
      builder: (context, snapshot) {
        //show error
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Oooops...'),
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }

        //show page
        if (snapshot.connectionState == ConnectionState.done) {
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

        //show loading..
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
