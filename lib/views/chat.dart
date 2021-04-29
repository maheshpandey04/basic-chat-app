import 'package:flutter/material.dart';
import 'package:mychat/helper/authenticate.dart';
import 'package:mychat/helper/constants.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/services/auth.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/views/conversation.dart';
import 'package:mychat/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  AuthMethods authMethods=new AuthMethods();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConverstaionScreen(
              chatRoomId
            )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mychat/helper/authenticate.dart';
// import 'package:mychat/helper/constants.dart';
// import 'package:mychat/helper/helperfunctions.dart';
// import 'package:mychat/services/auth.dart';
// import 'package:mychat/services/database.dart';
// import 'package:mychat/views/conversation.dart';
// import 'package:mychat/views/search.dart';
// import 'package:mychat/views/signin.dart';
// import 'package:mychat/widgets/widget.dart';
//
//
// class ChatRoom extends StatefulWidget {
//   @override
//   _ChatRoomState createState() => _ChatRoomState();
// }
//
// class _ChatRoomState extends State<ChatRoom> {
//   AuthMethods authMethods=new AuthMethods();
//   DatabaseMethods databaseMethods=new DatabaseMethods();
//   Stream chatRoomsStream;
//   Widget chatRoomList(){
//     return StreamBuilder(
//       stream: chatRoomsStream,
//       builder: (context,snapshot){
//         return snapshot.hasData ? ListView.builder(
//           itemCount: snapshot.data.documents.length,
//             itemBuilder: (context,index){
//             return  ChatRoomTile(
//               snapshot.data.documents[index].data["chatroomId"]
//                   .toString().replaceAll("_", "").
//                 replaceAll(Constants.myName, ""),
//                 snapshot.data.documents[index].data["chatroomId"]
//             );
//             }):Container();
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     getUserInfo();
//     super.initState();
//   }
//
//
//   getUserInfo()async{
//     Constants.myName=await HelperFunctions.getUserNameSharedPreference();
//     databaseMethods.getChatRooms(Constants.myName).then((value){
//       setState(() {
//         chatRoomsStream=value;
//       });
//
//     });
//     setState(() {
//
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset("assets/images/logo.png",
//         height: 50,),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: (){
//               authMethods.signOut();
//               Navigator.pushReplacement(context, MaterialPageRoute(
//                 builder: (context)=>Authenticate()
//               ));
//             },
//             child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.exit_to_app)),
//           )
//         ],
//       ),
//       body: chatRoomList(),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.search),
//         onPressed: (){
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context)=>SearchScreen()
//           ));
//         },
//       ),
//     );
//   }
// }
// class ChatRoomTile extends StatelessWidget {
//   final String userName;
//   final String chatRoom;
//   ChatRoomTile(this.userName,this.chatRoom);
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context,MaterialPageRoute(
//           // builder: (context)=>ConversationScreen()
//           builder: (context)=>ConversationScreen(chatRoom)
//         ));
//       },
//       child: Container(
//         color: Colors.black26,
//         padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
//         child: Row(
//           children: <Widget>[
//             Container(
//               height: 40,
//               width: 40,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(40)
//               ),
//               child: Text("${
//                   userName.substring(0,1).toUpperCase()}",
//               style: mediumTextFieldStyle(),),
//
//             ),
//             SizedBox(width: 8,),
//             Text(userName,style: mediumTextFieldStyle(),)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
