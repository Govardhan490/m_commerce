import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'signup.dart';
import 'main.dart';
import 'cart.dart';
import 'orders.dart';

class NavBarUI extends StatefulWidget
{
  NavBarUI({Key key}) : super(key: key);

  @override
  _NavBarUIState createState() => _NavBarUIState();

}

class _NavBarUIState extends State<NavBarUI>{

  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoggedIn;
  @override
  void initState() {
    isLoggedIn = false;
    auth.currentUser().then((user) => user != null ? setState(() {isLoggedIn = true;}) : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              child: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("M-Commerce",style: TextStyle(fontSize: 20),),
                    ),
                  ],),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(),
                ),
              ),
            ),
            ListTile(
              title: Text('Your Cart'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Your Orders'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      );
    } else {
      return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              child: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("M-Commerce",style: TextStyle(fontSize: 20),),
                    ),
                  ],),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(),
                ),
              ),
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            ListTile(
              title: Text('Sign Up'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void logOut() async{
    await auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }
}