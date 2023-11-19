import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/utils/diologes.dart';

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
        final formKey = GlobalKey<FormState>();

        // RegistrationCompleted() async {
        //   try {
        //     log('username $userEmail');
        //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        //         .collection('ClientGstInfo')
        //         .where(
        //           'Email',
        //           isEqualTo: userEmail,
        //         )
        //         .get();

        //     if (querySnapshot.docs.isNotEmpty) {
        //       log('ddddd ${percentageController.text}');
        //       await querySnapshot.docs.first.reference.update({
        //         'isRegistrationCompleted': true,
        //       });

        //       log('profile updated');
        //     }
        //   } catch (e) {
        //     log('error $e');
        //   }
        // }

        setApplicationVerified(bool value) async {
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
                'application_verified': value,
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
                // 'showprogress':true,
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

        updateStatus(int num) async {
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
              await querySnapshot.docs.first.reference.update({
                'statuspercentage': num,
              });

              log('profile updated');
            }
          } catch (e) {
            log('error $e');
          }
        }

        checkValidate(String email, String gstNumber) {
          if (formKey.currentState!.validate()) {
            // Provider.of<AppliacationCheckProvider>(context, listen: false).setRegistrationCompletedLocalFalse();

            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.scale,
              showCloseIcon: true,
              title: 'Submit Information',
              desc: 'Do You want to Submit GST Information',
              btnOkColor: Colors.green,
              btnOkText: 'Yes',
              btnCancelText: 'Cancel',
              btnCancelOnPress: () {},
              btnCancelColor: Colors.red,
              buttonsTextStyle: AppStyle.poppinsBold16,
              dismissOnBackKeyPress: true,
              titleTextStyle: AppStyle.poppinsBoldGreen16,
              descTextStyle: AppStyle.poppinsBold16,
              transitionAnimationDuration: const Duration(milliseconds: 500),
              btnOkOnPress: () {
                Provider.of<AppliacationCheckProvider>(context, listen: false).gstNumberUpload(email, gstNumber);
                Navigator.pop(context);
              },
              buttonsBorderRadius: BorderRadius.circular(20),
            ).show();
          }
        }

        return AlertDialog(
          content: StreamBuilder(
              stream: APIs.getGstClientInformation(userEmail),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs ?? [];

                  final applicationVerified = data[0]['application_verified'];

                  return SizedBox(
                    height: size.height * 0.47,
                    // width: double.infinity,
                    child: applicationVerified == false
                        ? Consumer<AppliacationCheckProvider>(builder: (context, provider, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Update Application Status',
                                  style: AppStyle.poppinsBold20,
                                ),
                                SizedBox(height: size.height * 0.03),
                                ListTile(
                                  title: Text(
                                    'Checked Information',
                                    style: AppStyle.poppinsBold16,
                                  ),
                                  trailing: RoundCheckBox(
                                    onTap: (selected) {
                                      provider.isCheckInformation = selected!;
                                    },
                                    uncheckedColor: Colors.red,
                                    borderColor: blackColor,
                                    isChecked: provider.isCheckInformation == true ? true : false,
                                    uncheckedWidget: const Icon(Icons.close),
                                    animationDuration: const Duration(
                                      milliseconds: 50,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Checked Documents',
                                    style: AppStyle.poppinsBold16,
                                  ),
                                  trailing: RoundCheckBox(
                                    onTap: (selected) {
                                      provider.isCheckDocuments = selected!;
                                    },
                                    uncheckedColor: Colors.red,
                                    borderColor: blackColor,
                                    isChecked: provider.isCheckDocuments == true ? true : false,
                                    uncheckedWidget: const Icon(Icons.close),
                                    animationDuration: const Duration(
                                      milliseconds: 50,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Final Check',
                                    style: AppStyle.poppinsBold16,
                                  ),
                                  trailing: RoundCheckBox(
                                    onTap: (selected) {
                                      provider.isFinalCheck = selected!;
                                    },
                                    uncheckedColor: Colors.red,
                                    borderColor: blackColor,
                                    isChecked: provider.isFinalCheck == true ? true : false,
                                    uncheckedWidget: const Icon(Icons.close),
                                    animationDuration: const Duration(
                                      milliseconds: 50,
                                    ),
                                  ),
                                ),
                                // SizedBox(height: size.height * 0.03),
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: blackColor,

                                        // fixedSize: const Size(300, 100),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                      ),
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.scale,
                                          btnCancelColor: whiteColor,
                                          btnCancelOnPress: () {},
                                          btnOkColor: whiteColor,
                                          btnOkOnPress: () {
                                            if (provider.isCheckInformation == true) {
                                              updateStatus(40);
                                              isCheckInformationToDatbase();
                                            }

                                            if (provider.isCheckDocuments == true) {
                                              updateStatus(70);
                                              isCheckDocumentsToDatbase();
                                            }

                                            if (provider.isFinalCheck == true) {
                                              updateStatus(100);
                                              isFinalCheckToDatbase();
                                              setApplicationVerified(true);
                                              // RegistrationCompleted();

                                              // Provider.of<AppliacationCheckProvider>(context, listen: false).setRegistrationCompletedLocalTrue();
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
                                        style: AppStyle.poppinsBoldWhite16,
                                      )),
                                ),
                                // SizedBox(height: size.height * 0.02),
                                Center(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'back',
                                      style: AppStyle.poppinsBold12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          })
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Updata GST Number to client',
                                style: AppStyle.poppinsBold12,
                              ),
                              SizedBox(height: size.height * 0.02),
                              Form(
                                key: formKey,
                                child: TextFormField(
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
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter gst Number';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Consumer<AppliacationCheckProvider>(builder: (context, provider, child) {
                                return MaterialButton(
                                  onPressed: () {
                                    provider.pickFile(
                                      userEmail,
                                      gstNumberController.text.trim(),
                                    );
                                  },
                                  child: Text(
                                    'Upload Gst Certificate',
                                    style: AppStyle.poppinsBold12,
                                  ),
                                );
                              }),
                              Consumer<AppliacationCheckProvider>(builder: (context, provider, child) {
                                return Visibility(
                                  visible: provider.fileUploading == true,
                                  child: Text('file Uploading....', style: AppStyle.poppinsBold12),
                                );
                              }),
                              Consumer<AppliacationCheckProvider>(builder: (context, provider, child) {
                                return Visibility(
                                  visible: provider.fileUploaded == true,
                                  child: Text('file Uploaded', style: AppStyle.poppinsBoldGreen12),
                                );
                              }),
                              SizedBox(height: size.height * 0.01),
                              ElevatedButton(
                                onPressed: () {
                                  checkValidate(
                                    userEmail,
                                    gstNumberController.text.trim(),
                                  );
                                },
                                child: Text(
                                  'Submit',
                                  style: AppStyle.poppinsBold12,
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'back',
                                    style: AppStyle.poppinsBold12,
                                  ),
                                ),
                              )
                            ],
                          ),
                  );
                } else {
                  return SizedBox(
                    height: size.height * 0.4,
                    child: const Center(
                      child: SpinKitCircle(color: blackColor),
                    ),
                  );
                }
              }),
        );
      },
    );
  }

  // ----------------------------------------------------------------------------

  static GridView pdfView(BuildContext context, List<File> paths) {
    final pdfPaths = paths.sublist(1);

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
        var path = pdfPaths[index];

        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PdfViewerScreen(pdfUrl: Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs[index]),
            //   ),
            // );
            OpenFile.open(path.path);
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

Expanded rejectButton(BuildContext context, var userData, String email) {
  return Expanded(
    child: Consumer<AppliacationCheckProvider>(builder: (context, value, child) {
      return InkWell(
        onTap: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            showCloseIcon: true,
            title: 'Reject Application',
            desc: 'Do You want to Reject Application',
            btnOkColor: Colors.green,
            btnOkText: 'Yes',
            btnCancelText: 'Cancel',
            btnCancelOnPress: () {},
            btnCancelColor: Colors.red,
            buttonsTextStyle: AppStyle.poppinsBold16,
            dismissOnBackKeyPress: true,
            titleTextStyle: AppStyle.poppinsBoldRed16,
            descTextStyle: AppStyle.poppinsBold16,
            transitionAnimationDuration: const Duration(milliseconds: 500),
            btnOkOnPress: () {
              MessagingAPI.sendPushNotification(
                userData['message_token'],
                'your Application Denied',
                'Denied',
              );
              Diologes.showSnackbar(context, 'Application Denied');
              Provider.of<AppliacationCheckProvider>(context, listen: false).notifyNotVerified(userData['Email']);
              value.verificationStatusToTrue();
              setAcceptAcceptButtonTrue(email);
            },
            buttonsBorderRadius: BorderRadius.circular(20),
          ).show();
        },
        child: Container(
          height: 53,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'REJECT',
              style: AppStyle.poppinsBold16,
            ),
          ),
        ),
      );
    }),
  );
}

Expanded acceptButton(BuildContext context, var userData, String email) {
  return Expanded(
    child: Consumer<AppliacationCheckProvider>(builder: (context, value, child) {
      return InkWell(
        onTap: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            showCloseIcon: true,
            title: 'Accept Application',
            desc: 'Do You want to Accept Application',
            btnOkColor: Colors.green,
            btnOkText: 'Yes',
            btnCancelText: 'Cancel',
            btnCancelOnPress: () {},
            btnCancelColor: Colors.red,
            buttonsTextStyle: AppStyle.poppinsBold16,
            dismissOnBackKeyPress: true,
            titleTextStyle: AppStyle.poppinsBoldGreen16,
            descTextStyle: AppStyle.poppinsBold16,
            transitionAnimationDuration: const Duration(milliseconds: 500),
            btnOkOnPress: () {
              MessagingAPI.sendPushNotification(
                userData['message_token'],
                'your Application Successfully verified',
                'Application verified',
              );
              Diologes.showSnackbar(context, 'Application Accepted');

              Provider.of<AppliacationCheckProvider>(context, listen: false).notifyVerified(
                userData['Email'],
              );

              value.verificationStatusToTrue();
              setAcceptAcceptButtonTrue(email);
            },
            buttonsBorderRadius: BorderRadius.circular(20),
          ).show();
        },
        child: Container(
          height: 53,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'ACCEPT',
              style: AppStyle.poppinsBold16,
            ),
          ),
        ),
      );
    }),
  );
}

setAcceptAcceptButtonTrue(String emal) async {
  try {
    log('username $emal');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClientGstInfo')
        .where(
          'Email',
          isEqualTo: emal,
        )
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'acceptbutton': true,
      });

      log('profile updated');
    }
  } catch (e) {
    log('error $e');
  }
}
