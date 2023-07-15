import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/constants.dart';

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails({super.key, required this.appoinmentData});

  final DocumentSnapshot appoinmentData;

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  String? serviceName;

  String? clientName;

  Future<String?> getClientInformation() async {
    String clientId = widget.appoinmentData['id'];
    CollectionReference referenceUser = FirebaseFirestore.instance.collection('ClientDetails');

    QuerySnapshot<Object?> snapshot = await referenceUser.where('Email', isEqualTo: clientId).get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;

      return data['Name'];
    } else {
      return null;
    }
  }

  Future<String?> getGstInformation() async {
    String gstId = widget.appoinmentData['gstId'];
    CollectionReference referenceGst = FirebaseFirestore.instance.collection('ClientGstInfo');
    DocumentSnapshot snapshot = await referenceGst.doc(gstId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      return data['ServiceName'];
    } else {
      log('document does not exist');

      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    // getClientInformation().then((value) {
    //   setState(() {
    //     clientName = value;
    //   });
    // });

    // getGstInformation().then((value) {
    //   setState(() {
    //     serviceName = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 40,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Appoinment Details',
                  style: AppStyle.poppinsBold27,
                ),
                FutureBuilder<String?>(
                    future: getClientInformation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error fetching data',
                          style: AppStyle.poppinsBold16,
                        );
                      } else {
                        clientName = snapshot.data;
                        return buildClientNameRow();
                      }
                    }),
                FutureBuilder<String?>(
                  future: getGstInformation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        strokeWidth: 2,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error to fetch data',
                        style: AppStyle.poppinsBold16,
                      );
                    } else {
                      serviceName = snapshot.data;

                      return buildServiceNameRow();
                    }
                  },
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: blackColor.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Sheduled Time',
                                textAlign: TextAlign.left,
                                style: AppStyle.poppinsRegular15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ':',
                                style: AppStyle.poppinsBold16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                widget.appoinmentData['time'],
                                textAlign: TextAlign.left,
                                style: AppStyle.poppinsBold16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Sheduled Date',
                                textAlign: TextAlign.left,
                                style: AppStyle.poppinsRegular15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ':',
                                style: AppStyle.poppinsBold16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                widget.appoinmentData['date'],
                                textAlign: TextAlign.left,
                                style: AppStyle.poppinsBold16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildServiceNameRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Client Service',
            textAlign: TextAlign.left,
            style: AppStyle.poppinsRegular15,
          ),
        ),
        Expanded(
          child: Text(
            ':',
            style: AppStyle.poppinsBold16,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            serviceName ?? '',
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Widget buildClientNameRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Client Name',
            textAlign: TextAlign.left,
            style: AppStyle.poppinsRegular15,
          ),
        ),
        Expanded(
          child: Text(
            ':',
            style: AppStyle.poppinsBold16,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            clientName ?? '',
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }
}
