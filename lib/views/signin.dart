import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/services/auth.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/widgets/widget.dart';

import 'chat.dart';
class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods=new AuthMethods();
  final formKey=GlobalKey<FormState>();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();

  bool isLoading=false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).
      then((val){
        snapshotUserInfo=val;
        HelperFunctions
            .saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });
      setState(() {
        isLoading=true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
        if(val !=null){

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=>ChatRoom()
          ));
        }

      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
    body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Please Provide a valid EmailId";
                      },
                      controller: emailTextEditingController,
                      style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("email"),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return val.length>6 ?null :"Please Provide password 6+ character";
                      },
                      controller: passwordTextEditingController,
                      style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("password"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text("Forgot Password",style: simpleTextFieldStyle(),),
                ),
              ),
              SizedBox(height: 8,),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding:EdgeInsets.symmetric(vertical: 20) ,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(30)
                  ),

                  child: Text("Sign In",
                    style: mediumTextFieldStyle(),
                    ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding:EdgeInsets.symmetric(vertical: 20) ,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),

                child: Text("Sign In with Google",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0
                  ),),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: mediumTextFieldStyle()),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Register now",style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        decoration: TextDecoration.underline
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),

            ],

          ),
        ),
      ),
    ),


    );
  }
}
