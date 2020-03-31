import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'display_list.dart';
import 'navBarUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'M-Commerce'),
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category :Icon(Icons.book,size: 100,color: Colors.pink), categoryname :"Books"),
                    onPressed: () {
                      displaylistpage(context,"Books");
                    }),
              ),
              Spacer(flex: 2),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.phone_android,size: 100,color: Colors.pink),categoryname: "Mobiles"),
                    onPressed: () {
                      displaylistpage(context,"Mobiles");
                    }),
              ),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.computer,size: 100,color: Colors.pink),categoryname : "Computers"),
                    onPressed: () {
                      displaylistpage(context,"Computers");
                    }),
              ),
              Spacer(flex: 2),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.devices_other,size: 100,color: Colors.pink),categoryname :"Electronics"),
                    onPressed: () {
                      displaylistpage(context,"Electronics");
                    }),
              ),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Spacer(flex: 1),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.tv,size: 100,color: Colors.pink),categoryname :"TV"),
                    onPressed: () {
                      displaylistpage(context,"TV");
                    }),
              ),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    drawer: NavBarUI(),
    );
  }

  void displaylistpage(BuildContext context,String categoryname) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayList(category : categoryname)),
    );
  }
}

class Category extends StatelessWidget {
  final Icon category;
  final String categoryname;
  Category({Key key,this.category,this.categoryname}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column (
      children : [
        category,
        Text(categoryname,style: TextStyle(fontSize: 20,color: Colors.black)),
      ],
    );
  }
}
