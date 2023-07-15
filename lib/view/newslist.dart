import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/view/news_add.dart';

class NewsListTile extends StatelessWidget {
  NewsListTile({super.key});

  final newsDetails = FirebaseFirestore.instance
      .collection('news')
      .orderBy(
        'time',
        descending: true,
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: newsDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var newsData = snapshot.data!.docs;

              return Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: double.infinity,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'News List',
                          style: AppStyle.poppinsBold24,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsAdd(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_box_outlined),
                          color: blackColor,
                          iconSize: 40,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    newsData.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: newsData.length,
                            primary: false,
                            itemBuilder: (context, index) {
                              var id = newsData[index].id;
                              log('dddddd   $id');
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onLongPress: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.scale,
                                      btnCancelColor: whiteColor,
                                      btnCancelOnPress: () {},
                                      btnOkColor: whiteColor,
                                      btnOkOnPress: () {
                                        try {
                                          log(id);
                                          FirebaseFirestore.instance.collection('news').doc(id).delete();
                                        } catch (e) {
                                          log(e.toString());
                                        }
                                      },
                                      desc: 'Delete Message',
                                      descTextStyle: AppStyle.poppinsBold16,
                                      buttonsTextStyle: AppStyle.poppinsBold12,
                                      dismissOnBackKeyPress: true,
                                      useRootNavigator: true,
                                    ).show();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: blackColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 100,
                                            width: 70,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: newsData[index]['image'],
                                                placeholder: (context, url) => const Center(
                                                  child: SpinKitThreeBounce(
                                                    color: blackColor,
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error, size: 40),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  newsData[index]['newsHeading'],
                                                  // 'jkdsjaajkjajkdkjsakkdajkkahdkjjkdajkjjkjkjjkajkkjkjdjjkajjdajklajkjkldiajjkajaj',
                                                  style: AppStyle.poppinsBold16,
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 10),
                                                  // color: Colors.blue,
                                                  child: Text(
                                                    newsData[index]['auther'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppStyle.poppinsRegular12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              'NO data found',
                              style: AppStyle.poppinsBold24,
                            )),
                          )
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text(
                  'error to fetch data ${snapshot.error}',
                  style: AppStyle.poppinsBold16,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
