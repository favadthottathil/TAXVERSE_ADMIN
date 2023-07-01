import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';

class ApplicationCheckWidgets {
  static Future<dynamic> customDialog(
    BuildContext context,
    Size size,
    String userEmail,
    TextEditingController percentageController,
    TextEditingController gstNumberController,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) {
        bool isCheckInformation = true;
        bool isCheckDocuments = false;
        bool isFinalCheck = false;

        bool RegistrationCompletedLocal = false;

        RegistrationCompleted() async {
          try {
            log('username $userEmail');
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('ClientGstInfo')
                .where(
                  'Email',
                  isEqualTo: userEmail,
                )
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              log('ddddd ${percentageController.text}');
              await querySnapshot.docs.first.reference.update({
                'isRegistrationCompleted': true,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        isFinalCheckToDatbase() async {
          try {
            log('username $userEmail');
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('ClientGstInfo')
                .where(
                  'Email',
                  isEqualTo: userEmail,
                )
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              log('ddddd ${percentageController.text}');
              await querySnapshot.docs.first.reference.update({
                'verifystatus': 2,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        isCheckDocumentsToDatbase() async {
          try {
            log('username $userEmail');
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('ClientGstInfo')
                .where(
                  'Email',
                  isEqualTo: userEmail,
                )
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              log('ddddd ${percentageController.text}');
              await querySnapshot.docs.first.reference.update({
                'verifystatus': 1,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        isCheckInformationToDatbase() async {
          try {
            log('username $userEmail');
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('ClientGstInfo')
                .where(
                  'Email',
                  isEqualTo: userEmail,
                )
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              log('ddddd ${percentageController.text}');
              await querySnapshot.docs.first.reference.update({
                'verifystatus': 0,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        updateStatus() async {
          int number = int.parse(percentageController.text);

          try {
            log('username $userEmail');
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('ClientGstInfo')
                .where(
                  'Email',
                  isEqualTo: userEmail,
                )
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              log('ddddd ${percentageController.text}');
              await querySnapshot.docs.first.reference.update({
                'statuspercentage': number,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SizedBox(
              height: size.height * 0.5,
              width: double.infinity,
              child: RegistrationCompletedLocal == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.1),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Enter Progress bar Percentage', style: AppStyle.poppinsBold12),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: percentageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.01),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: blackColor, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: blackColor, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        ListTile(
                          title: Text(
                            'Checked Information',
                            style: AppStyle.poppinsBold12,
                          ),
                          trailing: Checkbox(
                            value: isCheckInformation,
                            onChanged: (value) {
                              setState(() {
                                isCheckInformation = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Checked Documents',
                            style: AppStyle.poppinsBold12,
                          ),
                          trailing: Checkbox(
                            value: isCheckDocuments,
                            onChanged: (value) {
                              setState(
                                () {
                                  isCheckDocuments = value!;
                                },
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Final Check',
                            style: AppStyle.poppinsBold12,
                          ),
                          trailing: Checkbox(
                            value: isFinalCheck,
                            onChanged: (value) {
                              setState(
                                () {
                                  isFinalCheck = value!;
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.scale,
                                  btnCancelColor: whiteColor,
                                  btnCancelOnPress: () {},
                                  btnOkColor: whiteColor,
                                  btnOkOnPress: () {
                                    if (percentageController.text.isNotEmpty) {
                                      updateStatus();
                                      percentageController.clear();
                                    }

                                    if (isCheckInformation == true) {
                                      isCheckInformationToDatbase();
                                    }

                                    if (isCheckDocuments == true) {
                                      isCheckDocumentsToDatbase();
                                    }

                                    if (isFinalCheck == true) {
                                      isFinalCheckToDatbase();
                                      RegistrationCompleted();
                                      setState(() {
                                        RegistrationCompletedLocal = true;
                                      });
                                    }

                                    Navigator.pop(context);
                                  },
                                  desc: 'Save Changes',
                                  descTextStyle: AppStyle.poppinsBold16,
                                  buttonsTextStyle: AppStyle.poppinsBold12,
                                  dismissOnBackKeyPress: true,
                                  useRootNavigator: true,
                                ).show();
                              },
                              child: Text(
                                'Save Changes',
                                style: AppStyle.poppinsBold12,
                              )),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Updata GST Number to client',
                          style: AppStyle.poppinsBold12,
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextField(
                          controller: gstNumberController,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.01),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: blackColor, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: blackColor, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            'Upload Gst Certificate',
                            style: AppStyle.poppinsBold12,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Submit',
                            style: AppStyle.poppinsBold12,
                          ),
                        )
                      ],
                    ),
            ),
          );
        });
      },
    );
  }

  // ----------------------------------------------------------------------------

  static GridView pdfView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 5,
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(pdfUrl: Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs[index]),
              ),
            );
          },
          child: Column(
            children: [
              sizedBoxHeight10,
              Image.asset(
                'Asset/pngwing.com.png',
                height: 120,
                width: 200,
              ),
              // sizedBoxHeight10,
              Expanded(
                child: Text(
                  Provider.of<AppliacationCheckProvider>(context, listen: false).pdfsNames[index],
                  style: AppStyle.poppinsRegular15,
                  // overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  void initilisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);

    setState(() {});
  }

  @override
  void initState() {
    initilisePdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document != null
          ? PDFViewer(document: document!)
          : const Center(
              child: SpinKitThreeBounce(
                color: blackColor,
              ),
            ),
    );
  }
}
