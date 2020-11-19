import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutterapp/Services/auth.dart';
//import 'package:flutterapp/Shared/loading.dart';

//import 'ChoicePage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {

  static const String id = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String Email = '';
  String Password = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:
        Column(

          crossAxisAlignment: CrossAxisAlignment.start ,
          children: <Widget>[
            Container(
                child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(130.0, 28.0, 0.0, 0.0),
                        child: Text(
                          'on  va',
                          style: TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(180.0, 15.0, 0.0, 0.0),
                            child: Text(
                                'Y',
                                style: TextStyle(
                                    fontSize: 70.0, fontWeight: FontWeight.bold, color: Colors.green)
                            ),
                          ),
                        ],
                      ),
                    ]
                )
            ),
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,

                child: Column(
                  children: <Widget>[

                    TextFormField(
                      validator: (value) => value.isEmpty ? 'Enter a valid Email' : null,

                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black38
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (value){

                        setState(() => Email = value

                        );
                      } ,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (value) => value.length < 6 ? 'Enter a 6 character Password': null,
                      decoration: InputDecoration(
                          labelText: 'MOT de PASSE',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black38
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      obscureText: true,
                      onChanged: (value){

                        setState(() => Password = value

                        );
                      } ,
                    ),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        child: Text('Oubliez Mot de Passe',
                          style: TextStyle(color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0,),
                    RaisedButton(
                      color: Colors.green,
                      elevation: 5.0,

                      child: Text('Login',
                        style: TextStyle(color: Colors.white),
                      ),

                      onPressed: ()async{
                        if (_formKey.currentState.validate()){
                          setState(() => loading = true

                          );
                         // dynamic result = await _auth.signinwithemailandpwd(Email.trim(), Password);
                         //  if(result == null){
                         //    setState((){
                         //      error = 'Check your Credentials';
                         //      loading = false;
                         //    }
                         //
                         //
                         //    );
                         //  } else {
                         //
                         //  }
                        }

                      },
                    ),


                    SizedBox(height: 25.0,),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black38,
                              style: BorderStyle.solid,
                              width: 1.0
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Center(
                              child: Text('Log in avec Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  )),
                            )
                          ],
                        ),
                      ),

                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )

                  ],
                ),
              ),
            )
          ],
        )

    );
  }


}

