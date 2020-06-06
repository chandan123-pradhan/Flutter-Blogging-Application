import 'package:blogging/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DialogBox.dart';

import 'dart:io';

class UploadPhotoPage extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>
{

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

  TextEditingController DescriptionUser = TextEditingController();
   DialogBox dialogBox=new DialogBox();

  File sampleImage;
  String _myValue;
  String url;

  final formKey=new GlobalKey<FormState>();

  Future getImage()async
  {
    var tempImage=await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage=tempImage;
    });
  }

  void validateAndSave() async
  {
    String description=DescriptionUser.text;
    if(description.isEmpty)
    {
      dialogBox.information(context, "Error: ", "Description is Required, Plese Write Description");
      
    }
    else
    {
      final StorageReference postImageRef=FirebaseStorage.instance.ref().child("Post Images");

      var timeKey=new DateTime.now();

      final StorageUploadTask uploadTask= postImageRef.child(timeKey.toString()+".jpeg").putFile(sampleImage);

      var ImageUrl= await (await uploadTask.onComplete).ref.getDownloadURL();

      url=ImageUrl.toString();

      toast("Image Uploaded Successfully");

      _myValue=description;

      gotoHomePage();

      saveToDatabase(url);
      
    }
  }


  void saveToDatabase(url)
  {
    var dbTimeKey=new DateTime.now();

  

    var formateDate=new DateFormat('MMM d, yyyy');

    var formateTime=new DateFormat('EEEE , hh : mm aaa');

    String date=formateDate.format(dbTimeKey);

    String time=formateTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data=
    {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };
    ref.child("Posts").push().set(data);
  }
// for after upload image this function return you to home page
  void gotoHomePage()
  {
     Navigator.pushAndRemoveUntil(context,
     MaterialPageRoute(builder: (context)=>HomePage()),
    (Route<dynamic> route)=>false);
    
    /*Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context)
      {
        return new HomePage();
      }
      
        
      )
    );*/
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold
    (
        appBar: new AppBar
        (
          title: new Text("Upload Image"),
          centerTitle: true,
        ),
        body: new Center
        (
          child: sampleImage == null ? Text("Select an Image") : enableUpload(),
        ),

        floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
          tooltip: "Add Image",
          child: new Icon(Icons.add_a_photo),
        ),
    );
  }


  Widget enableUpload()
  {
    return new Scaffold
    ( 
     
        
        body: Padding(

           padding: EdgeInsets.all(10), 
           child: ListView(
            children: <Widget>[
            

          Image.file(sampleImage, height: 330.0, width: 660.0 ,),

          Container(
          padding: EdgeInsets.all(10),

          

          child: TextFormField
          (
            decoration: new InputDecoration(
              labelText: "Description",),
              controller: DescriptionUser,

          ),
          ),

         

          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(60, 10, 60, 0),
             
              child: RaisedButton(
                onPressed: validateAndSave,
                textColor: Colors.white,
                color: Colors.pink,
                child: Text("Upload"
               ),
                ),
          ),
          


       ],
      ),
      ),

     );
    
  }
}