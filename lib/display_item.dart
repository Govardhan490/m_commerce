import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcommerce/display_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup.dart';
import 'login.dart';

class DisplayItem extends StatefulWidget
{
  final Items item;
  DisplayItem({Key key,this.item}): super(key: key);

  @override
  _DisplayItemState createState() => _DisplayItemState();

}

class _DisplayItemState extends State<DisplayItem> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn;
  @override
  void initState() {
    isLoggedIn = false;
    _auth.currentUser().then((user) => user != null ? setState(() {isLoggedIn = true;}) : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.productname),
      ),
      body: Container(
        color: Colors.amberAccent,
        child: Card(
          elevation: 10.00,
          margin: EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Container(
                  width: 300,
                  child: Image.network(widget.item.photo,width:screenSize.width-60,height: 200, fit:BoxFit.scaleDown),
                ),
                SizedBox(height: 10.0),
                Text("Rs . "+widget.item.price,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(widget.item.description,style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.justify),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              width: screenSize.width*0.5,
              child: MaterialButton(
                onPressed: (){ addToCart(widget.item.key);},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_shopping_cart,color: Colors.black,size: 30,),
                    Text("  Add To Cart",style: TextStyle(color: Colors.black ),),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.orange,
              width: screenSize.width*0.5,
              child: MaterialButton(
                onPressed: (){ buy(widget.item.key);},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.shopping_cart,color: Colors.black,size: 30),
                      Text("  Buy",style: TextStyle(color: Colors.black)),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
      );
  }

  Future<void> addToCart(String key) async{
    if(isLoggedIn) {
      final FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;
      DatabaseReference ref = FirebaseDatabase.instance.reference().child("users/customers/"+uid+"/cart");
      var data = {key : 1};
      await ref.update(data);
      Fluttertoast.showToast(
          msg: "Item Added to Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else {
      print(key);
      showdialog();
    }
  }

  Future<void> buy(String key) async{
    if(isLoggedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Buying Confirmation"),
            content: new Text("Are you sure you want to Buy?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                  buyConfirm(key);
                },
              ),
              FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
    else {
      print(key);
      showdialog();
    }
  }

  Future<void> buyConfirm(String key) async{
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("users/customers/"+uid+"/orders/"+key);
    await ref.once().then((DataSnapshot snapshot){
      if (snapshot.value != null){
        DatabaseReference newRef = FirebaseDatabase.instance.reference().child("users/customers/"+uid+"/orders/");
        var newData = {key : snapshot.value+1};
        newRef.update(newData);
      }
      else {
        DatabaseReference newRef = FirebaseDatabase.instance.reference().child("users/customers/"+uid+"/orders/");
        var newData = {key : 1};
        newRef.update(newData);
      }
    });
    Fluttertoast.showToast(
        msg: "Order Placed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void showdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("You are not Logged In"),
          content: new Text("Please Log In or Sign Up"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Log In"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder:
                      (context) => Login(),
                ),
                ).then((_) {
                  initState();
                });
              },
            ),
            FlatButton(
              child: new Text("Sign Up"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder:
                      (context) => SignUp(),
                ),
                ).then((_) {
                    initState();
                });
              },
            ),
            FlatButton(
              child: new Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}