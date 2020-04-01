import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayItem extends StatelessWidget
{
  String keys,available,description,owner,photo,price,productname;
  DisplayItem(this.keys,this.available,this.description,this.owner,this.photo,this.price,this.productname);
  
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.productname),
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
                  child: Image.network(this.photo,width:screenSize.width-60,height: 200, fit:BoxFit.scaleDown),
                ),
                SizedBox(height: 10.0),
                Text("Rs . "+this.price,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(this.description,style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.justify),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}