
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/helper/constants.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/widgets/widget.dart';

class ConverstaionScreen extends StatefulWidget {
  final String chatRoomId;
  ConverstaionScreen(this.chatRoomId);
  @override
  _ConverstaionScreenState createState() => _ConverstaionScreenState();
}

class _ConverstaionScreenState extends State<ConverstaionScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;
  Widget ChatMessageList() {
    return StreamBuilder(stream: chatMessagesStream,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
          return MessageTile(snapshot.data.documents[index].data["message"],
              snapshot.data.documents[index].data["sendBy"]==Constants.myName);
          }
      ):Container();
    },);

  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text=" ";
    }
  }
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream=value;
      });
    });
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Stack(
            children: <Widget>[
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter
                ,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                color: Colors.white54
                            ),
                            decoration: InputDecoration(
                                hintText: "Message....",
                                hintStyle: TextStyle(
                                    color: Colors.white54
                                ),
                                border: InputBorder.none
                            ),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0x36FFFFFF),
                                      const Color(0x0FFFFFFF)

                                    ]

                                ),
                                borderRadius: BorderRadius.circular(40)
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset("assets/images/send.png")),
                      )
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(left: isSendByMe ? 0:24,right: isSendByMe? 24:0),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment:isSendByMe ? Alignment.centerRight :Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe?[
              const Color(0xff007EF4),
                const Color(0xff2A75BC)
                ]
                : [
                const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
            ],
            ),
            borderRadius: isSendByMe?
                BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24)
                ):
            BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24)
            )

          ),
          child: Text(message,style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
      );
    }
  }
  





// class ConversationScreen extends StatefulWidget {
//   final String chatRoomId;
//
//   ConversationScreen(this.chatRoomId);
//
//   @override
//   _ConversationScreenState createState() => _ConversationScreenState();
// }
//
// class _ConversationScreenState extends State<ConversationScreen> {
//
//   Stream<QuerySnapshot> chats;
//   TextEditingController messageEditingController = new TextEditingController();
//
//   Widget chatMessages(){
//     return StreamBuilder(
//       stream: chats,
//       builder: (context, snapshot){
//         return snapshot.hasData ?  ListView.builder(
//             itemCount: snapshot.data.documents.length,
//             itemBuilder: (context, index){
//               return MessageTile(
//                 message: snapshot.data.documents[index].data["message"],
//                 sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
//               );
//             }) : Container();
//       },
//     );
//   }
//
//   addMessage() {
//     if (messageEditingController.text.isNotEmpty) {
//       Map<String, dynamic> chatMessageMap = {
//         "sendBy": Constants.myName,
//         "message": messageEditingController.text,
//         'time': DateTime
//             .now()
//             .millisecondsSinceEpoch,
//       };
//
//       DatabaseMethods().addConversationMessages(widget.chatRoomId, chatMessageMap);
//
//       setState(() {
//         messageEditingController.text = "";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     DatabaseMethods().getConversationMessages(widget.chatRoomId).then((val) {
//       setState(() {
//         chats = val;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarMain(context),
//       body: Container(
//         child: Stack(
//           children: [
//             chatMessages(),
//             Container(alignment: Alignment.bottomCenter,
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                 color: Color(0x54FFFFFF),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: TextField(
//                           controller: messageEditingController,
//                           style: simpleTextFieldStyle(),
//                           decoration: InputDecoration(
//                               hintText: "Message ...",
//                               hintStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                               border: InputBorder.none
//                           ),
//                         )),
//                     SizedBox(width: 16,),
//                     GestureDetector(
//                       onTap: () {
//                         addMessage();
//                       },
//                       child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0x36FFFFFF),
//                                     const Color(0x0FFFFFFF)
//                                   ],
//                                   begin: FractionalOffset.topLeft,
//                                   end: FractionalOffset.bottomRight
//                               ),
//                               borderRadius: BorderRadius.circular(40)
//                           ),
//                           padding: EdgeInsets.all(12),
//                           child: Image.asset("assets/images/send.png",
//                             height: 25, width: 25,)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
//
// class MessageTile extends StatelessWidget {
//   final String message;
//   final bool sendByMe;
//
//   MessageTile({@required this.message, @required this.sendByMe});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//           top: 8,
//           bottom: 8,
//           left: sendByMe ? 0 : 24,
//           right: sendByMe ? 24 : 0),
//       alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: sendByMe
//             ? EdgeInsets.only(left: 30)
//             : EdgeInsets.only(right: 30),
//         padding: EdgeInsets.only(
//             top: 17, bottom: 17, left: 20, right: 20),
//         decoration: BoxDecoration(
//             borderRadius: sendByMe ? BorderRadius.only(
//                 topLeft: Radius.circular(23),
//                 topRight: Radius.circular(23),
//                 bottomLeft: Radius.circular(23)
//             ) :
//             BorderRadius.only(
//                 topLeft: Radius.circular(23),
//                 topRight: Radius.circular(23),
//                 bottomRight: Radius.circular(23)),
//             gradient: LinearGradient(
//               colors: sendByMe ? [
//                 const Color(0xff007EF4),
//                 const Color(0xff2A75BC)
//               ]
//                   : [
//                 const Color(0x1AFFFFFF),
//                 const Color(0x1AFFFFFF)
//               ],
//             )
//         ),
//         child: Text(message,
//             textAlign: TextAlign.start,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontFamily: 'OverpassRegular',
//                 fontWeight: FontWeight.w300)),
//       ),
//     );
//   }
// }
//
//
//
// class ConversationScreen extends StatefulWidget {
//   final String chatRoomId;
//   ConversationScreen(this.chatRoomId);
//   @override
//   _ConversationScreenState createState() => _ConversationScreenState();
// }
//
// class _ConversationScreenState extends State<ConversationScreen> {
//
//   DatabaseMethods databaseMethods=new DatabaseMethods();
//   TextEditingController messageController=new TextEditingController();
//   Stream chatMessageStream;
//   Widget ChatMessageList(){
//     return StreamBuilder(
//       stream: chatMessageStream,
//       builder: (context,snapshot){
//         return snapshot.hasData?ListView.builder(
//           itemCount: snapshot.data.documents.length,
//             itemBuilder:(context,index){
//             return MessageTile(snapshot.data.documents[index].data["message"],
//                 snapshot.data.documents[index].data["sendBy"]==Constants.myName) ;
//
//             }):Container();
//       },
//     );
//
//
//   }
//   sendMessage(){
//     if(messageController.text.isNotEmpty) {
//       Map<String, dynamic> messageMap = {
//         "message": messageController.text,
//         "sendBy":Constants.myName,
//         "time":DateTime.now().millisecondsSinceEpoch
//       };
//
//       databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
//       messageController.text="";
//     }
//   }
//   @override
//   void initState() {
//     databaseMethods.getConversationMessages(widget.chatRoomId).them((value){
//       setState(() {
//         chatMessageStream=value;
//       });
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:appBarMain(context) ,
//       body: Container(
//         child: Stack(
//           children: <Widget>[
//             ChatMessageList(),
//             Container(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       color: Color(0x54FFFFFF),
//                       padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
//
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                               child:TextField(
//                                 controller: messageController,
//                                 style: TextStyle(
//                                     color: Colors.white
//                                 ),
//                                 decoration: InputDecoration(
//                                     hintText: "Message....",
//                                     hintStyle: TextStyle(
//                                         color: Colors.white54
//                                     ),
//                                     border: InputBorder.none
//                                 ),
//                               )
//                           ),
//                           GestureDetector(
//                             onTap: (){
//                               sendMessage();
//                             },
//                             child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                         colors: [
//                                           const Color(0x36FFFFFF),
//                                           const Color(0x0FFFFFFF)
//                                         ]),
//                                     borderRadius: BorderRadius.circular(40)
//
//                                 ),
//                                 padding: EdgeInsets.all(12),
//                                 child: Image.asset("assets/images/send.png")),
//                           )
//                         ],
//                       ),
//                     ),
//                     //searchList()
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class MessageTile extends StatelessWidget {
//   final String message;
//   final bool isSendByMe;
//   MessageTile(this.message,this.isSendByMe);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left:  isSendByMe ?0:24,),
//       margin: EdgeInsets.symmetric(vertical: 8),
//       width: MediaQuery.of(context).size.width,
//       alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors:isSendByMe ? [
//                 const Color(0xff007EF4),
//                 const Color(0xff2A75BC)
//               ]
//                   : [
//                 const Color(0x1AFFFFFF),
//                 const Color(0x1AFFFFFF)
//               ],
//           ),
//           borderRadius: isSendByMe?
//               BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//                 bottomLeft: Radius.circular(24)
//               ):
//           BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//               bottomRight: Radius.circular(24)
//           )
//
//         ),
//         child: Text(message,style: TextStyle(
//             color: Colors.white, fontSize: 17
//         ),),
//       ),
//     );
//   }
// }

