import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'main.dart';

class Login extends StatefulWidget
{
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
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
                    login();
                  }
                },
                child: Text('Sign In'),
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

  Future<void> login() async {
    String password = _passwordController.text;
    String email = _emailController.text;

    signin(email,password);
    dynamic result = await signin(email, password);
    if(result == null)
    {
      setState(() {
        error = "Sign In Unsuccessful";
        _passwordController.text = "";
        _emailController.text = "";
      });
    }
    else {
      Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  Future signin(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


}