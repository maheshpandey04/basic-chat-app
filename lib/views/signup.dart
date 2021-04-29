import 'package:flutter/material.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/services/auth.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/views/chat.dart';
import 'package:mychat/widgets/widget.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading=false;
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();


  final formkey=GlobalKey<FormState>();
  TextEditingController userNameTextEditingController=new TextEditingController();
  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();



  signMeUp(){
    if(formkey.currentState.validate()){
      Map<String , String> userInfoMap={
        "name" :userNameTextEditingController.text,
        "email" :emailTextEditingController.text

      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);



      setState(() {
        isLoading=true;
      });
      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
            //print("${val.uId}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);


            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=>ChatRoom()
            ));
      });



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 4 ? "Please provide valid Username" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("username"),
                      ),
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
                  onTap:(){
                    signMeUp();
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

                    child: Text("Sign Up",
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

                  child: Text("Sign Up with Google",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0
                    ),),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: mediumTextFieldStyle()),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("SignIn now",style: TextStyle(
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
