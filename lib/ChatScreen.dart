import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:softomatic/image_picker.dart';
import 'package:softomatic/add_members_pop_up.dart';
import 'package:softomatic/message_widget.dart';
import 'package:softomatic/notification_services.dart';
import 'package:softomatic/database_services.dart';
import 'package:http/http.dart' as http;

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key,
      required this.username,
      required this.id,
      required this.groupName});
  final String username;
  final int id;
  final String groupName;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  List _selectedItems = [];
  void _showPopUp() async {
    final List items = [
      'aman',
      'amit',
      'devenerd',
      ' Virat Kohli',
      'KL Rahul',
      'Mohd. Shami'
    ];
    final List? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddMemebrsPopUp(
            items: items,
          );
        });
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
      for (String members in _selectedItems) {
        DatabaseService(uid: '1')
            .addMember(widget.id.toString(), widget.username, '1', members);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _message.dispose();
  }

  @override
  void initState() {
    super.initState();
    NotificationService().requestNotificationPermission();
    NotificationService().initInfo(context);
    NotificationService().firebaseInit();
    // DatabaseService(uid: '1')
    //     .createGroup(widget.groupName, widget.id.toString(), widget.username);
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      final response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAJ_ChHN8:APA91bGMVb2lO6l-MhxEhndqIdbkyOGQpk4eJufnecNJbClMcXiham0K7sXQeXi0--MX0B5I38XWD3d3HamPu8sd4CHwW6SOh-LEhyjl2_cp2suYVhuGueZlrqcTLwyIJcfWVjabyPJ5'
              },
              body: jsonEncode(<String, dynamic>{
                'priority': 'high',
                // 'data': <String, dynamic>{
                //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                //   'status': 'done',
                //   'body': body,
                //   'title': title,
                // },
                "notification": <String, dynamic>{
                  "title": title,
                  "body": body,
                  //"android_channel_id": 'softomatic'
                },
                "to": token,
              }));
      print(response);
    } catch (e) {
      print(e.toString());
    }
  }

  // String token =
  //     'cHwkw07QTai6PAIEkMC4wr:APA91bG3CTQmSAPB4o11Io5ROnFLZh9oQR5EJsqI12pqITcpg8e994VlKn41uMLSgmfzy2EqBzKGDykCK56q3h7YKG7qYe0Ln11VPb_uJKbnFaa3VaJWVlx0z9AyPh9q1tpEPHkg8E1Q';

  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref('Chat');

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)), // Apply border radius of 0.2
          ),
          backgroundColor: Colors.black,
          elevation: 16,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Chat',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _showPopUp();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 25,
                )),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //   height: size.height / 1.25,
            //   width: size.width,
            //   //   child: StreamBuilder<QuerySnapshot >(
            //   //     stream: _firestore.collection('chatroom').doc(chatRoomid).collection('chats').orderBy('time' , descending: false).snapshots(),
            //   // builder: ( BuildContext context , AsyncSnapshot<QuerySnapshot > snapshot){
            //   //       if(snapshot.data != null ){
            //   //         return ListView.builder(
            //   //             itemCount: snapshot.data!.docs.length,
            //   //             itemBuilder: (context , index) {
            //   //               Map <String , dynamic> map = snapshot.data!.docs[index].data()  as Map<String , dynamic>;
            //   //               return messages(size, map);
            //   //             });
            //   //       }
            //   child: messages(size, {}),
            // ),
            Expanded(
                child: FirebaseAnimatedList(
                    query: databaseRef.child(widget.id.toString()),
                    itemBuilder: (context, snapshot, animation, index) {
                      return messages(size, snapshot);
                    })),
            Container(
              height: size.height / 12,
              width: size.width,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        pickFile();
                      },
                      icon: const Icon(
                        Icons.attachment,
                        color: Colors.blue,
                      )),
                  SizedBox(
                    height: size.height / 17,
                    width: size.width / 1.5,
                    child: TextFormField(
                      controller: _message,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Type here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (_message.text.trim() != '') {
                          databaseRef
                              .child(widget.id.toString())
                              .child(Timestamp.now().toString())
                              .set({'id': '1', 'message': _message.text});
                          //getToken();
                          String? token =
                              await NotificationService().getToken();
                          sendPushMessage(token, _message.text, 'username');
                        }

                        FocusScope.of(context).unfocus();
                        _message.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
