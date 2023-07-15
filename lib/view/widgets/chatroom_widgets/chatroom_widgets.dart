import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/chatRoom_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/utils/date_util.dart';
import 'package:taxverse_admin/utils/diologes.dart';

class ChatRoomWidgets {
  static Widget chatInput({required String docId, required ChatRoomProvider provider, required BuildContext context, required TextEditingController message, required String userid}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      provider.emojiState();
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: blackColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: message,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (provider.showEmoji) {
                          provider.emojiState();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type Something....',
                        hintStyle: AppStyle.poppinsBold16,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await provider.pickFromGallery();
                      for (var i in provider.imageUrls) {
                        provider.sendImage(i, userid);
                      }
                      provider.imageUrls.clear();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: blackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await provider.pickFromCamera();

                      provider.sendImage(provider.imageUrl, userid);
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              final _message = message.text.trim();

              if (_message.isNotEmpty) {
                provider.sendMessage(_message, userid);
                message.clear();

                MessagingAPI.sendPushNotification(provider.clientToken, _message, 'admin');
              }
            },
            shape: const CircleBorder(),
            minWidth: 0,
            padding: const EdgeInsets.all(10),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.isSender,
    required this.updateRead,
    required this.docId,
  });

  final Object? message;

  final bool isSender;

  final void Function(String) updateRead;

  final String docId;

  @override
  Widget build(BuildContext context) {
    if (!isSender) {
      updateRead(docId);
    }

    return isSender
        ? Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              children: [
                InkWell(
                  onLongPress: () {
                    modelBottomsheetChat(context, docId);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 10, top: 20, left: 40),
                        decoration: BoxDecoration(
                          // color: Colors.blue.shade100,
                          border: Border.all(color: blackColor),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                (message as Map<String, dynamic>)['image'] == ''
                                    ? Text(
                                        (message as Map<String, dynamic>)['text'],
                                        // 'jdjjdfs',
                                        style: AppStyle.poppinsBold16,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: (message as Map<String, dynamic>)['image'],
                                          errorWidget: (context, url, error) {
                                            return Center(
                                              child: Text(
                                                'Unable To Fetch Image',
                                                style: AppStyle.poppinsBold16,
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) => const Center(
                                            child: SpinKitThreeBounce(color: blackColor, size: 40),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: _buildTickIcon((message as Map<String, dynamic>)['read']),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(right: 17),
                        child: Text(
                          MyDateUtil.getFormattedTime(
                            context: context,
                            time: (message as Map<String, dynamic>)['time'],
                          ),
                          style: AppStyle.poppinsRegular12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                      margin: const EdgeInsets.only(left: 20, top: 20, right: 60),
                      decoration: BoxDecoration(
                        // color: Colors.blue.shade100,
                        border: Border.all(color: blackColor),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          (message as Map<String, dynamic>)['image'] == ''
                              ? Text(
                                  (message as Map<String, dynamic>)['text'],
                                  style: AppStyle.poppinsBold16,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: (message as Map<String, dynamic>)['image'],
                                    errorWidget: (context, url, error) {
                                      return Center(
                                        child: Text(
                                          'Unable To Fetch Image',
                                          style: AppStyle.poppinsBold16,
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) => const SpinKitCircle(color: blackColor),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        MyDateUtil.getFormattedTime(
                          context: context,
                          time: (message as Map<String, dynamic>)['time'],
                        ),
                        style: AppStyle.poppinsRegular12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  Future<dynamic> modelBottomsheetChat(BuildContext context, String docID) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 150),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            checkImage(message: message)
                ? _OptionItme(
                    icon: const Icon(Icons.copy_sharp),
                    name: 'Copy Text',
                    onTap: () async {
                      try {
                        await Clipboard.setData(
                          ClipboardData(
                            text: (message as Map<String, dynamic>)['text'],
                          ),
                        ).then((value) {
                          Navigator.pop(context);
                          Diologes.showSnackbar(context, 'Text Copied');
                        });
                      } catch (e) {
                        print('hjjdfsdjdssjjdjdsjjsd $e');
                      }
                    },
                  )
                : _OptionItme(
                    icon: const Icon(
                      Icons.download,
                      color: whiteColor,
                    ),
                    name: '',
                    onTap: () {},
                  ),
            Divider(
              color: blackColor.withOpacity(1),
              endIndent: 10,
              indent: 10,
            ),
            _OptionItme(
              icon: const Icon(Icons.delete_outline),
              name: 'Delete Message',
              onTap: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: 'Delete Message',
                  desc: 'Are you really want to delete this message',
                  btnOkColor: whiteColor,
                  btnCancelColor: whiteColor,
                  buttonsTextStyle: AppStyle.poppinsBold12,
                  btnOkOnPress: () async {
                    // Navigator.pop(context);

                    await APIs.deleteChat(docId, message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  btnCancelOnPress: () {},
                ).show();
                // Navigator.pop(context);
              },
            ),
            // _OptionItme(icon: const Icon(Icons.copy_sharp), name: 'Copy Text', onTap: () {}),
          ],
        );
      },
    );
  }
}

class _OptionItme extends StatelessWidget {
  final Icon icon;

  final String name;

  final VoidCallback onTap;

  const _OptionItme({required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
        child: Row(
          children: [
            icon,
            Text(
              '    $name',
              style: AppStyle.poppinsBold12,
            ),
          ],
        ),
      ),
    );
  }
}

_buildTickIcon(String read) {
  if (read.isNotEmpty) {
    return const Icon(
      Icons.done_all_rounded,
      size: 20,
      color: Colors.blue,
    );
  } else {
    return const Icon(
      Icons.done_rounded,
      size: 20,
    );
  }
}
