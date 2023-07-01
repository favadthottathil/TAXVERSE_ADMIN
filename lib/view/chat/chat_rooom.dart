import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/chatRoom_provider.dart';
import 'package:taxverse_admin/view/widgets/chatroom_widgets/chatroom_widgets.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.userid,
    required this.username,
  });

  final String userid;

  final String username;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String currentDocumentId = '';

  final TextEditingController _message = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // getUserInfo() {
  //   FirebaseAuth auth = FirebaseAuth.instance;

  //   User? user = auth.currentUser;

  //   String uid = user!.uid;

  //   firestore.collection('ClientDetails').doc(uid).snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<ChatRoomProvider>(builder: (context, value, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (value.showEmoji) {
              value.emojiState();

              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: blackColor,
              leading: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                ),
              ),
              title: StreamBuilder(
                stream: firestore.collection('ClientDetails').where('Email', isEqualTo: widget.userid).limit(1).snapshots(),
                builder: (context, snapshot) {
                  final client = snapshot.data?.docs;
                  if (snapshot.data != null) {
                    final checkOnline = client![0]['is_online'] ? 'online' : 'client is offline';

                    value.clientToken = client[0]['message_token'];
                    clientToken1 = client[0]['message_token'];

                    if (snapshot.connectionState == ConnectionState.none) {
                      print('error');
                      return const SizedBox();
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          color: blackColor,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          // 'jdjakdahsaah',
                          style: AppStyle.poppinsBoldWhite18,
                        ),
                        Text(
                          checkOnline,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          // 'jdjakdahsaah',
                          style: AppStyle.poppinsBoldWhite18,
                        ),
                        Text(
                          'failed to check user status',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            body: Consumer<ChatRoomProvider>(builder: (context, provider, _) {
              return Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: firestore
                            .collection('chats')
                            .where(
                              'participants',
                              arrayContains: widget.userid,
                            )
                            .orderBy(
                              'time',
                              descending: true,
                            )
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.active) {
                            final messages = snapshot.data?.docs ?? [];

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: messages.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final message = messages[index].data();
                                currentDocumentId = messages[index].id;

                                final isSendMessage = (message as Map<String, dynamic>)['sender'] == widget.userid;
                                return MessageCard(
                                  message: message,
                                  isSender: isSendMessage,
                                  updateRead: provider.updateMessageReadStatus,
                                  docId: currentDocumentId,
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: SpinKitFadingCircle(color: blackColor),
                            );
                          }
                        },
                      ),
                    ),
                    if (provider.isUploading)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 20),
                          child: const SpinKitThreeBounce(
                            color: blackColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ChatRoomWidgets.chatInput(
                      docId: currentDocumentId,
                      provider: provider,
                      context: context,
                      message: _message,
                      userid: widget.userid,
                    ),
                    if (value.showEmoji)
                      SizedBox(
                        height: size.height * .35,
                        child: EmojiPicker(
                          textEditingController: _message,
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.0),
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ), // Needs to be const Widget
                            loadingIndicator: const SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
                      )
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
