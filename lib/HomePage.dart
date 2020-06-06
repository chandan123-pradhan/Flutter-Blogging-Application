import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginRegisterPage.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget {

  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState(){
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

List <Posts> postsLists=[];

@override
  void initState() {
    
    super.initState();

    DatabaseReference postsRef=FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap)
    
    {
      var KEYS= snap.value.keys;
      var DATA= snap.value;

      postsLists.clear;

      for(var individualKey in KEYS)
      {
        Posts posts = new Posts
        (
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postsLists.add(posts);
      }

      setState(() {
        //
      });
    });


  }

final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;



  toast(String message){
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white
      );
}

  void _logout()async
  {
    try{
      _firebaseAuth.signOut();  
      Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context)=>LoginRegisterPage()),
      (Route<dynamic> route)=>false);    
      
    }
    catch(e)
    {
      toast("Erro: "+e.toString());
    }
  }
   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Home"),

      ),
      body: new Container(

        child: postsLists.length==0 ? new Text("No Blog Post available"): new ListView.builder
        (
          itemCount:  postsLists.length,
          itemBuilder: (_,index)
          {
            return PostUi(postsLists[index].image , postsLists[index].description ,postsLists[index].date, postsLists[index].time);
          },
        ),

      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.pink,
        child: new Container(

          margin: EdgeInsets.only(left: 50,right: 50),

          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.local_car_wash),
                  iconSize: 40,
                  color: Colors.white,
                  //on pressed
                  onPressed: _logout,
              ),

               new IconButton(
                  icon: new Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.white,
                  //on pressed
                  onPressed: (){
                    Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context){
                        return UploadPhotoPage();
                      })
                    );

                  },
              ),
            ],
          ),
        ),

      ),

    
    );
    
    
  }


  Widget PostUi(String image, String description, String date,String time)
  {
    return new Card
    (
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),


      child: new Container
      (
        padding: EdgeInsets.all(14.0),
        child: new Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>
          [
            new Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text
                (
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),


                new Text
                (
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            SizedBox(height: 10.0),

            new Image.network(image, fit:BoxFit.cover,),

            SizedBox(height: 10.0),

            new Text
                (
                  description,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                ),

            
          ],
        

        ),

      ),
    );
  }
}