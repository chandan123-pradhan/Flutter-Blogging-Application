import 'package:blogging/Authentication.dart';
import 'package:blogging/moveToRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DialogBox.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomePage.dart';


class LoginRegisterPage extends StatefulWidget
{
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;


  State <StatefulWidget> createState()
  {
    return _LoginRegisterState();
  }

  
}

class _LoginRegisterState extends State<LoginRegisterPage>
{
  DialogBox dialogBox=new DialogBox();


TextEditingController loginEmail = TextEditingController();
TextEditingController loginPassword = TextEditingController();
final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

    toast(String message){
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.pink[200],
        textColor: Colors.white
      );
}
  String _email;
  String _password;

  void login()async
  {

    _email=loginEmail.text;
    _password=loginPassword.text;

    if(_email.isEmpty &&  _password.isEmpty)
      dialogBox.information(context, "Error: ", "Email and Password are require please enter Email ID and Password ");
    else
    if(_email.isEmpty)
      dialogBox.information(context, "Error: ", "Email is require please enter your Email ID ");
    else
    if(_password.isEmpty)
     dialogBox.information(context, "Error: ", "Password is require please enter your Email Password ");

    else{
      try{
        FirebaseUser user=await _firebaseAuth.signInWithEmailAndPassword(email:_email, password: _password);
        toast("Congratulations You Have Logged Successfully");
         Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (context)=>HomePage()),
         (Route<dynamic> route)=>false);
         
      }
      catch(e)
      {
        dialogBox.information(context, "Error ", e.toString());
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      
        appBar: AppBar(
          title: new Text("Bloggin"),
        ),
       body: Padding(
         
        
        padding: EdgeInsets.all(10), 
        child: ListView(
          children: <Widget>[
           logo(),
            //SECOND CONTAINER FOR NEXT ELEMENT
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: loginEmail,
              
                
                decoration: InputDecoration(
                  
                  
                  border: OutlineInputBorder(
                    
                  ),
                  labelText: "User Name:"
                ),
              ),
             
            ),
            Container(
              
              padding: EdgeInsets.all(10),
              child: TextField( 
              controller: loginPassword,
              obscureText: true,
              decoration: InputDecoration(
              
              border: OutlineInputBorder(),
              labelText: "Password",
            ),
            ),
            ),
           
           
          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
             
              child: RaisedButton(
                onPressed: (){
                  login();
                },
                textColor: Colors.white,
                color: Colors.pink,
                child: Text("Login"
               ),
                ),
          ),

          Container(
            child: Row(
              children: <Widget>[
                
                FlatButton(
                  textColor: Colors.blue,
                  child: Text("Create new account?",
                  style: TextStyle(
                    fontSize: 14
                  ),),
                  onPressed:(){
                     Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context)=>moveToRegister()),
                    (Route<dynamic> route)=>false);
                  },
                  
                  )

            ],
            mainAxisAlignment: MainAxisAlignment.center,)
          ),
          ],
        ) 
      ),
    );
  }

  Widget logo()
  {
    return new Hero(

      tag: 'hero',


    child: new CircleAvatar(
    backgroundColor: Colors.transparent,
    
    radius: 110.0,

    child: Image.asset('images/app_logo.png'),
    ),
    );
  }



  



}