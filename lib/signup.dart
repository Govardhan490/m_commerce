import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget
{
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"),),
      body: Form(
      key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    hintText: "Enter your Name"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please fill this field';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Enter your Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid Email';
                  }
                  return null;
                },
               ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Enter your Password"),
                obscureText: true,
                validator: (value) {
                  if (value.length < 6) {
                    return 'Please enter a Password with more than Six Characters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                      signup();
                  }
                },
                child: Text('Sign Up'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(error,style: TextStyle(color: Colors.red,fontSize: 14),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    register(email,password);
    dynamic result = await register(email, password);
    if(result == null)
    {
       setState(() {
          error = "Sign Up Unsuccessful";
          _usernameController.text = "";
          _passwordController.text = "";
          _emailController.text = "";
       });
    }
    else {
      await addData(username,email);
      Navigator.pop(context);
    }
  }

  Future register(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<void> addData(String username, String email) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("users/customers/"+uid);
    var data = {
      "name" : username,
      "email" : email
    };
    ref.set(data);
  }
}