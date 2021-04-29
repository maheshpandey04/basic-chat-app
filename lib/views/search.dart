import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/helper/constants.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/views/conversation.dart';
import 'package:mychat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';







class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController searchTextEditingController=new TextEditingController();


  QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods.
    getUserByUserName(searchTextEditingController.text)
        .then((val){
      // print(val.toString());
      setState(() {
        searchSnapshot=val;
      });
    });
  }


  createChatRoomAndStartConversation({String userName}){
    if(userName!=Constants.myName){
      String chatRoomId=getChatRoomId(userName, Constants.myName);
      List <String> users=[userName,Constants.myName];
      Map<String,dynamic> chatRoomMap={
        "users":users,
        "chatRoomId":chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        // builder: (context)=>ConversationScreen()
           builder: (context) => ConverstaionScreen(
             chatRoomId
           )
      ));


    }else{
      print("You cannot Send Message To Yourself");
    }
    }
  Widget searchList(){
    return searchSnapshot!=null ? ListView.builder(
        itemCount:searchSnapshot.documents.length ,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userEmail: searchSnapshot.documents[index].data["name"],
            userName: searchSnapshot.documents[index].data["email"],
          );
        }
    ):Container();
  }
  Widget SearchTile({String userName,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName,style: mediumTextFieldStyle(),),
              Text(userEmail,style: mediumTextFieldStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(
                  userName:userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text("Message",style: mediumTextFieldStyle(),),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color:Color(0x54FFFFFF) ,
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child:TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                            color: Colors.white54
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Username....",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:[
                              const Color(0x36FFFFFF),
                              const  Color(0x0FFFFFFF)

                            ]

                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")),
                  )
                ],

              ),
            ),
            searchList()
          ],

        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}



