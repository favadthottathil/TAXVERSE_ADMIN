import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/shared_pref/application_check.dart';
import 'package:taxverse_admin/view/Application_Check/provider/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/view/widgets/decrypt_data.dart';
import 'widgets/application_check_widgets.dart';

class VerifyApplication extends StatefulWidget {
  const VerifyApplication({super.key, required this.gstdata, required this.userData});

  final DocumentSnapshot gstdata;

  final DocumentSnapshot userData;

  @override
  State<VerifyApplication> createState() => _VerifyApplicationState();
}

class _VerifyApplicationState extends State<VerifyApplication> {
  final percentageController = TextEditingController();

  final gstNumberController = TextEditingController();

  HashMap<String, File> documentFiles = HashMap();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final provider = Provider.of<AppliacationCheckProvider>(context, listen: false);

    final String gstEmail = widget.gstdata['Email'];

    final int count = widget.gstdata['Application_count'];

    checkSharedPreferenceValue(
      gstEmail,
      count,
      false,
      ApplicatinCheckShardpref().getIsCheckInformation(gstEmail, count),
      provider.getIsCheckInformation(gstEmail, count),
    );

    checkSharedPreferenceValue(
      gstEmail,
      count,
      false,
      ApplicatinCheckShardpref().getisCheckDocuments(gstEmail, count),
      provider.getIsCheckDocuments(gstEmail, count),
    );

    checkSharedPreferenceValue(
      gstEmail,
      count,
      false,
      ApplicatinCheckShardpref().getIsFinalCheck(gstEmail, count),
      provider.getIsFinalCheck(gstEmail, count),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: FutureBuilder(
            future: APIs.getFileFromFirebaseStorage(decrypedData(widget.gstdata['Email'], generateKey()), widget.gstdata['Application_count'].toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> documentNames = snapshot.data!.items.map((e) => e.name).toList();
                // final showAcceptAndRejectbutton = widget.gstdata['acceptbutton'];
                final showupdateStatusToClient = widget.gstdata['application_status'];
                return FutureBuilder(
                    future: downloadAndDecryptFiles(documentNames),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.03,
                              top: size.height * 0.03,
                              right: size.width * 0.05,
                              bottom: size.height * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                verificationApplicationText(),
                                SizedBox(height: size.height * 0.01, width: size.width * 0.2),
                                serviceName(),
                                SizedBox(height: size.height * 0.01, width: size.width * 0.2),
                                clientDetailsText(),
                                sizedBoxHeight20,
                                fullNameRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: 30,
                                ),
                                sizedBoxHeight20,
                                companyNameRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                businessTypeRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                businessStartDateRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                clientPhotoRow(size, documentFiles),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                panCardRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                aadhaarCardRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                sizedBoxHeight20,
                                electricityBillRow(),
                                Divider(
                                  color: blackColor.withOpacity(0.1),
                                  thickness: 1,
                                  height: size.height * 0.04,
                                ),
                                Text('Client Documents', style: AppStyle.poppinsBold16),
                                sizedBoxHeight20,
                                ApplicationCheckWidgets.pdfView(context, documentFiles),
                                if (showupdateStatusToClient == '' || showupdateStatusToClient == 'accepted')
                                  Align(
                                    child: MaterialButton(
                                      onPressed: () {
                                        ApplicationCheckWidgets.customDialog(
                                          context,
                                          size,
                                          widget.gstdata['Email'],
                                          percentageController,
                                          gstNumberController,
                                          widget.gstdata['Application_count'],
                                        );
                                      },
                                      child: Text(
                                        'Update Status To Client',
                                        style: AppStyle.poppinsBold16,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: size.height * 0.02),
                                // if (Provider.of<AppliacationCheckProvider>(context, listen: false).verificatinStatus == false)
                                StreamBuilder(
                                    stream: APIs.getGstClientInformation(widget.gstdata['Email'], widget.gstdata['Application_count']),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final showAcceptAndRejectbutton = snapshot.data!.docs[0]['acceptbutton'] ?? [];

                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (showAcceptAndRejectbutton)
                                              rejectButton(
                                                context,
                                                widget.userData,
                                                widget.gstdata['Email'],
                                                widget.gstdata['Application_count'],
                                              ),
                                            const SizedBox(width: 30),
                                            if (showAcceptAndRejectbutton)
                                              acceptButton(
                                                context,
                                                widget.userData,
                                                widget.gstdata['Email'],
                                                widget.gstdata['Application_count'],
                                              )
                                          ],
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    })
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return Center(child: Text('Downloading documents.....', style: AppStyle.poppinsBold16));
                      }
                    });
              } else if (snapshot.hasError) {
                log(snapshot.error.toString());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: SpinKitCircle(color: blackColor));
              }

              return const Center(child: Text('No Data Found'));
            },
          ),
        ),
      ),
    );
  }

  void checkSharedPreferenceValue(String gstEmail, int count, bool value, Future<bool?> checkFunction, Future<void> setFunction) {
    checkFunction.then((value) {
      if (value == null) {
        setFunction;
      }
    });
  }

  getdatafromStorage() async {
    var data = await APIs.getFileFromFirebaseStorage(decrypedData(widget.gstdata['Email'], generateKey()), widget.gstdata['Application_count'].toString());

    return data;
  }

  Row electricityBillRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Electricity bill',
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
            decrypedData(widget.gstdata['electricityBill'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row aadhaarCardRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'AadhaarNO',
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
            decrypedData(widget.gstdata['AadhaarCard'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row panCardRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'PanCardNO',
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
            decrypedData(widget.gstdata['PanCardNumber'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row clientPhotoRow(Size size, HashMap<String, File> documentsFiles) {
    final profilePath = documentFiles['PassportSizePhoto']!;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Client Passport size photo',
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
          child: SizedBox(
            height: size.height * 0.18,
            width: size.width * 0.18,
            child: Image.file(profilePath),
          ),
        ),
      ],
    );
  }

  Row businessStartDateRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Business StartDate',
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
            decrypedData(widget.gstdata['BusinessStartDate'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row businessTypeRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Business Type',
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
            decrypedData(widget.gstdata['BusinesssType'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row companyNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Company Name',
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
            decrypedData(widget.gstdata['BusinessName'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row fullNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Full Name',
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
            decrypedData(widget.gstdata['name'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Text clientDetailsText() {
    return Text(
      "Client Details",
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      style: AppStyle.poppinsBold16,
    );
  }

  Text serviceName() {
    return Text(
      'Service: ${widget.gstdata['ServiceName']}',
      textAlign: TextAlign.left,
      style: AppStyle.poppinsBold16,
    );
  }

  Text verificationApplicationText() {
    return Text(
      'Verify Application',
      textAlign: TextAlign.left,
      style: AppStyle.poppinsBold27,
    );
  }

  // Download and decrypt each file
  Future<List<dynamic>> downloadAndDecryptFiles(List<String> documentNames) async {
    List visited = [];

    final String decryptedMail = decrypedData(widget.gstdata['Email'], generateKey());

    for (String fileName in documentNames) {
      await APIs.downloadEncryptedPdfFile(decryptedMail, widget.gstdata['Application_count'], fileName, documentFiles);
    }

    print('full success');

    return visited;
  }
}
