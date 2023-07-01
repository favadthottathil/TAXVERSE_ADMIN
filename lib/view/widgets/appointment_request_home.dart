import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/constants.dart';
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
                                appointment[index]['username'],
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
