import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'moveToRegister.dart';
import 'HomePage.dart';
import 'Authentication.dart';


class MappinPage extends StatefulWidget
{
  final AuthImplementation auth;

  MappinPage
  ({

    this.auth,
  });
State<StatefulWidget> createState()
{
  return _MappingPageState();
}

}

enum AuthStatus
{
  notSignedIn,
  signedIn,
}


class _MappingPageState extends State<MappinPage>
{
  AuthStatus authStatus=AuthStatus.notSignedIn;

  @override
  void initState()
   {
    
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId)
    {
      setState(() {
        authStatus= firebaseUserId ==null ?  AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

void _signedIn()
{
  setState(() {
    authStatus=AuthStatus.signedIn;
  });
}

void _signOut()
{
  setState(() {
    authStatus=AuthStatus.notSignedIn;
  });
}


  @override
  Widget build(BuildContext context) {

    switch(authStatus)
    {
      case AuthStatus.notSignedIn:
        return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

        case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signOut,
        );
      
    }

    return null;
    
  }
}