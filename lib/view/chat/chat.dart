import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/utils/date_util.dart';
import 'package:taxverse_admin/view/chat/chat_rooom.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  Map<String, dynamic>? clientMap;

  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  final clientdata = FirebaseFirestore.instance.collection('ClientDetails').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getClientData() {
    return FirebaseFirestore.instance.collection('ClientDetails').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat List',
                style: AppStyle.poppinsBold27,
              ),
              SizedBox(
                height: size.height / 30,
              ),
              ChatCard(admindata: clientdata),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.admindata,
  });

  final Stream<QuerySnapshot<Map<String, dynamic>>> admindata;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: admindata,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
          var admin = snapshot.data?.docs;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: admin!.length,
            itemBuilder: (context, index) {
              return Container(
                color: blackColor.withOpacity(0.1),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(
                          userid: admin[index]['Email'],
                          username: admin[index]['Name'],
                          // usermap: clientMap!,
                          // chatRoomId: rooomId,
                        ),
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      CupertinoIcons.person,
                      color: blackColor,
                    ),
                  ),
                  title: Text(
                    admin[index]['Name'],
                    style: AppStyle.poppinsBold16,
                    overflow: TextOverflow.clip,
                  ),
                  subtitle: SizedBox(
                    height: 16,
                    child: StreamBuilder(
                        stream: getLastMessage(admin[index]['Email']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final messges = snapshot.data?.docs;

                            final lastMessage = messges?.isNotEmpty == true ? messges!.first : null;

                            final String lastMessageText = lastMessage?.data()['text'] ?? '';

                            return Text(
                              lastMessageText,
                              style: AppStyle.poppinsRegular12,
                            );
                          } else {
                            return const Text('');
                          }
                        }),
                  ),
                  trailing: StreamBuilder(
                    stream: getLastMessage(admin[index]['Email']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messges = snapshot.data?.docs;

                        final lastMessage = messges?.isNotEmpty == true ? messges!.first : null;

                        final lastMessageTime = lastMessage?.data()['time'] ?? '';

                        return Text(
                          MyDateUtil.getFormattedTime(
                            context: context,
                            time: lastMessageTime,
                          ),
                          style: AppStyle.poppinsBold12,
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "No Data Found",
              style: AppStyle.poppinsBold20,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String clientId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .where(
        'participants',
        arrayContains: clientId,
      )
      .orderBy(
        'time',
        descending: true,
      )
      .limit(1)
      .snapshots();
}
