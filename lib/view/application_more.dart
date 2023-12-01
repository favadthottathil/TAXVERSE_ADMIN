import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/view/applcation_check.dart';

class ApplicationMore extends StatelessWidget {
  ApplicationMore({super.key});

  final clientdataCollection = FirebaseFirestore.instance
      .collection('GstClientInfo')
      .orderBy(
        'time',
        descending: false,
      )
      .snapshots();

  final userData = FirebaseFirestore.instance
      .collection(
        'ClientDetails',
      )
      .orderBy(
        'time',
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Applications",
                style: AppStyle.poppinsBold24,
              ),
              StreamBuilder(
                stream: clientdataCollection,
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.active) {
                    return StreamBuilder(
                      stream: userData,
                      builder: (context, snapshot2) {
                        if (snapshot2.connectionState == ConnectionState.active) {
                          var gstData = snapshot1.data?.docs ?? [];

                          var userData = snapshot2.data?.docs ?? [];

                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: gstData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyApplication(
                                          gstdata: gstData[index],
                                          userData: userData[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: blackColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(45),
                                            child: Image.asset(
                                              'Asset/3135715.png',
                                              height: 90,
                                              width: 90,
                                            ),
                                          ),
                                          const SizedBox(width: 25),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Name: ',
                                                          style: AppStyle.poppinsRegular16,
                                                        ),
                                                        TextSpan(
                                                          text: userData[index]['Name'],
                                                          style: AppStyle.poppinsBold16,
                                                        )
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Service: ',
                                                          style: AppStyle.poppinsRegular16,
                                                        ),
                                                        TextSpan(
                                                          text: gstData[index]['ServiceName'],
                                                          style: AppStyle.poppinsBold16,
                                                        )
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Status: ',
                                                          style: AppStyle.poppinsRegular16,
                                                        ),
                                                        TextSpan(
                                                          text: userData[index]['Isverified'] == 'verified' ? 'Accepted' : 'Not Accepted',
                                                          style: AppStyle.poppinsBold16,
                                                        )
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    );
                  } else if (snapshot1.hasError) {
                    return Center(
                      child: Text('Error to fetch Data ${snapshot1.error}'),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
