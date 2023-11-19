import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/view/widgets/decrypt_data.dart';
import 'widgets/application_check_wigets/application_check_widgets.dart';

class VerifyApplication extends StatelessWidget {
  VerifyApplication({super.key, required this.gstdata, required this.userData});

  final DocumentSnapshot gstdata;

  final DocumentSnapshot userData;

  final percentageController = TextEditingController();

  final gstNumberController = TextEditingController();

  HashMap<String, File> documentFiles = HashMap();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var applicationChechProvider = context.watch<AppliacationCheckProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: size.width * 0.03,
              top: size.height * 0.03,
              right: size.width * 0.05,
              bottom: size.height * 0.03,
            ),
            child: FutureBuilder(
              future: APIs.getFileFromFirebaseStorage(decrypedData(gstdata['Email'], generateKey()), gstdata['Application_count'].toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> documentNames = snapshot.data!.items.map((e) => e.name).toList();
                  final showAcceptAndRejectbutton = gstdata['acceptbutton'];
                  return FutureBuilder<List<String>>(
                      future: downloadAndDecryptFiles(documentNames, documentFiles),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length == 6) {
                            log('all data exists');
                          }

                          final allValues = documentFiles.values.toList();

                          return Column(
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
                              clientPhotoRow(size, allValues),
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
                              ApplicationCheckWidgets.pdfView(context, allValues),
                              Align(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {
                                    ApplicationCheckWidgets.customDialog(
                                      context,
                                      size,
                                      decrypedData(gstdata['Email'], generateKey()),
                                      percentageController,
                                      gstNumberController,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (showAcceptAndRejectbutton == false && applicationChechProvider.verificatinStatus == false)
                                    rejectButton(
                                      context,
                                      userData,
                                      decrypedData(gstdata['Email'], generateKey()),
                                    ),
                                  const SizedBox(width: 30),
                                  if (showAcceptAndRejectbutton == false && applicationChechProvider.verificatinStatus == false)
                                    acceptButton(
                                      context,
                                      userData,
                                      decrypedData(gstdata['Email'], generateKey()),
                                    )
                                ],
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(
                            child: SpinKitCircle(
                              color: blackColor,
                            ),
                          );
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
      ),
    );
  }

  getdatafromStorage() async {
    var data = await APIs.getFileFromFirebaseStorage(decrypedData(gstdata['Email'], generateKey()), gstdata['Application_count'].toString());

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
            decrypedData(gstdata['electricityBill'], generateKey()),
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
            decrypedData(gstdata['AadhaarCard'], generateKey()),
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
            decrypedData(gstdata['PanCardNumber'], generateKey()),
            textAlign: TextAlign.left,
            style: AppStyle.poppinsBold16,
          ),
        ),
      ],
    );
  }

  Row clientPhotoRow(Size size, List<File> allValues) {
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
            child: Image.file(allValues[0]),
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
            decrypedData(gstdata['BusinessStartDate'], generateKey()),
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
            decrypedData(gstdata['BusinesssType'], generateKey()),
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
            decrypedData(gstdata['BusinessName'], generateKey()),
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
            decrypedData(gstdata['name'], generateKey()),
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
      'Service: ${gstdata['ServiceName']}',
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

  Future<List<String>> downloadAndDecryptFiles(List<String> documentNames, HashMap<String, File> documentFiles) async {
    List<String> decryptedFilePaths = [];

    for (String fileName in documentNames) {
      await APIs.downloadEncryptedPdfFile(decrypedData(gstdata['Email'], generateKey()), gstdata['Application_count'], fileName, documentFiles);

      // decryptedFilePaths.add(decryptFilePath);
    }

    return decryptedFilePaths;
  }
}
