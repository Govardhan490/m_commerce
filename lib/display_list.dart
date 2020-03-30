import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class DisplayList extends StatefulWidget{
  final String category;
  DisplayList({Key key,this.category}): super(key: key);

  goBackToPreviousScreen(BuildContext context){

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Center(

      ),
    );
  }

  @override
  _DisplayListState createState() => _DisplayListState();
}

class Items
{
  String available,description,owner,photo,price,product_name;
  Items(this.available,this.description,this.owner,this.photo,this.price,this.product_name);
}

class _DisplayListState extends State<DisplayList>{

  List<Items> itemList = [];
  int no = 0;

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("users/Items/"+widget.category);
    ref.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      itemList.clear();

      for(var key in KEYS)
      {
        if(key != "No")
        {
          Items items = new Items(
              DATA[key]["available"],
              DATA[key]["description"],
              DATA[key]["owner"],
              DATA[key]["photo"],
              DATA[key]["price"],
              DATA[key]["product_name"]
          );

          itemList.add(items);
        }
      }

      setState(() {
        if(itemList.length == 0)
        {
          no = 1;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(itemList.length == 0 && this.no == 0) {
      print(this.no);
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: Center(
          child: Container(
            color: Colors.lightBlue,
            child: Center(
              child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink),
            ),
          ),
        ),
      );
    }
    else if(itemList.length == 0 && this.no == 1)
    {
      print(this.no);
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: Center(
          child: Text("No Items Added Yet!!!",style: TextStyle(fontSize: 15)),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: Container(
          color: Colors.amberAccent,
          child: ListView.builder(itemCount: itemList.length,itemBuilder:(_,index){return ItemsUI(
              itemList[index].product_name,
              itemList[index].photo,
              itemList[index].price,
              itemList[index].description.substring(0,49)+"...");}),
        ),
      );
    }
  }

  Widget ItemsUI(String name,String image,String price,String desc)
  {
    return MaterialButton(
      onPressed: null,
      elevation: 10.00,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Image.network(image,width: 300, height: 200, fit:BoxFit.fill),
              SizedBox(height: 10.0),
              Text("Rs . "+price,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Text(desc,style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.left),
            ],
          ),
        ),
      ),
    );
  }

}
