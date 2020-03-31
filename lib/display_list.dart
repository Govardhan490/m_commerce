import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'display_item.dart';

class DisplayList extends StatefulWidget{
  final String category;
  DisplayList({Key key,this.category}): super(key: key);

  @override
  _DisplayListState createState() => _DisplayListState();
}

class Items
{
  String key,available,description,owner,photo,price,productname;
  Items(this.key,this.available,this.description,this.owner,this.photo,this.price,this.productname);
}

class _DisplayListState extends State<DisplayList>{

  List<Items> itemList = [];
  int no = 0;

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("users/Items/"+widget.category);
    ref.once().then((DataSnapshot snap){
      var keys = snap.value.keys;
      var data = snap.value;

      itemList.clear();

      for(var key in keys)
      {
        if(key != "No")
        {
          Items items = new Items(
              key,
              data[key]["available"],
              data[key]["description"],
              data[key]["owner"],
              data[key]["photo"],
              data[key]["price"],
              data[key]["product_name"]
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
          child: ListView.builder(itemCount: itemList.length,itemBuilder:(_,index){return itemsui(itemList[index]);}),
        ),
      );
    }
  }

  void displayItem(BuildContext context,Items item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayItem(item : item)),
    );
  }

  Widget itemsui(Items item)
  {
    String desc;
    if(item.description.length < 100) {
      desc = item.description;
    }
    else{
      desc = item.description.substring(0,99);
    }
    var screenSize = MediaQuery.of(context).size;
    return MaterialButton(
      onPressed: (){
        displayItem(context,item);
        },
      elevation: 10.00,
      child: Card(
        child: Container(
          width: screenSize.width-10,
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(item.productname,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.network(item.photo,width:screenSize.width-60,height: 200, fit:BoxFit.scaleDown),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text("Rs . "+item.price,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Text(desc+"...",style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.left),
            ],
          ),
        ),
      ),
    );
  }

}
