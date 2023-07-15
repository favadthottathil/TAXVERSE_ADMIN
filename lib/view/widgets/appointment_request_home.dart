import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/view/applcation_check.dart';
import 'package:taxverse_admin/view/appoinment_pages/appoinment_details.dart';

class AppoinmentRequestHome extends StatelessWidget {
  const AppoinmentRequestHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appoinmentData = FirebaseFirestore.instance.collection('appointments').snapshots();
    return StreamBuilder(
      stream: appoinmentData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var appointment = snapshot.data!.docs;
          appoinmentGlobal = appointment;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: appointment.length > 2 ? 2 : appointment.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color: blackColor.withOpacity(0.1),
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: blackColor,
                            ),
                            child: Image.asset('Asset/3135715.png'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                appointment[index]['name'],
                                textAlign: TextAlign.center,
                                style: AppStyle.poppinsBold16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "Time:  ${appointment[index]['time']}",
                                  textAlign: TextAlign.center,
                                  style: AppStyle.poppinsRegular16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentDetails(appoinmentData: appointment[index]),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: whiteColor,
                              ),
                              child: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

ListView applicationList(List<QueryDocumentSnapshot<Map<String, dynamic>>> gstData) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: gstData.length > 3 ? 3 : gstData.length,
    itemBuilder: (context, index) {




      return StreamBuilder(
        stream: APIs.getUserData(gstData[index]['Email']),
        builder: (context, snapshot) {
          var userData = snapshot.data?.docs ?? [];
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyApplication(
                      gstdata: gstData[index],
                      userData: userData[0],
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
                                      text: gstData[index]['name'],
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
                                      text:
                                      //  userData[index]['Isverified'] == 'verified' ? 'Accepted' : 
                                      'Not Accepted',
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
        }
      );
    },
  );
}
