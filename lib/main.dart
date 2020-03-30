import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'display_list.dart';

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
      appBar: AppBar(
        title: Row(
            children :[
              IconButton(
                icon: Icon(Icons.menu),
                tooltip: 'Navigation menu',
                onPressed: null, // null disables the button
              ),
              Text(widget.title),
            ]
        ),
      ),
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
                    child: Category(category :Icon(Icons.book,size: 100,color: Colors.pink), category_name :"Books"),
                    onPressed: () {
                      display_list_page(context,"Books");
                    }),
              ),
              Spacer(flex: 2),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.phone_android,size: 100,color: Colors.pink),category_name: "Mobiles"),
                    onPressed: () {
                      display_list_page(context,"Mobiles");
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
                    child: Category(category : Icon(Icons.computer,size: 100,color: Colors.pink),category_name : "Computers"),
                    onPressed: () {
                      display_list_page(context,"Computers");
                    }),
              ),
              Spacer(flex: 2),
              Material(
                elevation: 10.0,
                child: MaterialButton(
                    child: Category(category : Icon(Icons.devices_other,size: 100,color: Colors.pink),category_name :"Electronics"),
                    onPressed: () {
                      display_list_page(context,"Electronics");
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
                    child: Category(category : Icon(Icons.tv,size: 100,color: Colors.pink),category_name :"TV"),
                    onPressed: () {
                      display_list_page(context,"TV");
                    }),
              ),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void display_list_page(BuildContext context,String category_name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayList(category : category_name)),
    );
  }
}

class Category extends StatelessWidget {
  final Icon category;
  final String category_name;
  Category({Key key,this.category,this.category_name}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column (
      children : [
        category,
        Text(category_name,style: TextStyle(fontSize: 20,color: Colors.black)),
      ],
    );
  }
}
