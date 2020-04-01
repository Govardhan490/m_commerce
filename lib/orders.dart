import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'displayCartOrder.dart';

class OrderList extends StatefulWidget
{
  OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class Items
{
  String key,available,description,owner,photo,price,productname;
  int ordered;
  Items(this.key,this.available,this.description,this.owner,this.photo,this.price,this.productname,this.ordered);
}

class _OrderListState extends State<OrderList>{
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _ref = FirebaseDatabase.instance.reference();
  List<Items> itemList = [];
  int no = 0;

  @override
  void initState() {
    super.initState();
    getOrderList();
  }

  Future<void> getOrderList() async{
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    itemList.clear();
    DatabaseReference orderRef = _ref.child("users/customers/"+uid+"/orders");
    orderRef.once().then((DataSnapshot snap) {
      if(snap.value == null)
      {
        setState(() {
          no = 1;
        });
      }
      else {
        var keys = snap.value.keys;
        var avail = snap.value;
        print(avail);
        for (var key in keys) {
          var path = key.toString().substring(0, key
              .toString()
              .length - 3);
          DatabaseReference itemRef = _ref.child("users/Items/"+path+"/"+key.toString());
          itemRef.once().then((DataSnapshot snapShot){
            var data = snapShot.value;
            Items items = new Items(
                key,
                data["available"],
                data["description"],
                data["owner"],
                data["photo"],
                data["price"],
                data["product_name"],
                avail[key]
            );

            itemList.add(items);
            setState(() {
              if(itemList.length == 0)
              {
                no = 2;
              }
            });
          });

        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    if(itemList.length == 0 && this.no == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
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
          title: Text("Orders"),
        ),
        body: Center(
          child: Text("No Orders Placed Yet!!!",style: TextStyle(fontSize: 15)),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
        ),
        body: Container(
          color: Colors.amberAccent,
          child: ListView.builder(itemCount: itemList.length,itemBuilder:(_,index){return itemsui(itemList[index]);}),
        ),
      );
    }
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DisplayItem(item.key,item.available,item.description,item.owner,item.photo,item.price,item.productname)),
        );
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
              Row(
                children: <Widget>[
                  Text("Rs . "+item.price,style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                  Spacer(flex: 1,),
                  MaterialButton(
                    onPressed: (){
                      if(item.ordered == 1){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Cancel Order"),
                              content: new Text("Are you sure to cancel this Order"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                FlatButton(
                                  child: new Text("Yes"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    removeItemFromOrder(item.key,0,item.ordered);
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
                      else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Cancel Order"),
                              content: new Text("Are you sure to Cancel this Order"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                FlatButton(
                                  child: new Text("Cacel All"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    removeItemFromOrder(item.key,2,item.ordered);
                                  },
                                ),
                                FlatButton(
                                  child: new Text("Cancel One"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    removeItemFromOrder(item.key,1,item.ordered);
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
                    },
                    child: Icon(Icons.delete,color: Colors.red,),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Text("Bought : "+ item.ordered.toString(),style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.left),
              SizedBox(height: 10.0),
              Text(desc+"...",style: Theme.of(context).textTheme.subhead,textAlign: TextAlign.left),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> removeItemFromOrder(String key,int flag,int ordered) async{
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    if(flag == 0 || flag == 2) {
      DatabaseReference orderRef = _ref.child("users/customers/"+uid+"/orders/"+key);
        await orderRef.remove();
    }
    else {
      DatabaseReference orderRef = _ref.child("users/customers/"+uid+"/orders");
      var data = {key : ordered-1};
      await orderRef.update(data);
    }
    setState(() {
      getOrderList();
    });
  }

}