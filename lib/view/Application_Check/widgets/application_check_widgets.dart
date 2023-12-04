import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/view/Application_Check/provider/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/utils/diologes.dart';

class ApplicationCheckWidgets {
  static Future customDialog(BuildContext context, Size size, String userEmail, TextEditingController percentageController, TextEditingController gstNumberController, int count) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();

        final appliCheckProvider = context.watch<AppliacationCheckProvider>();

        return AlertDialog(
          content: StreamBuilder(
              stream: APIs.getGstClientInformation(userEmail, count),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs ?? [];

                  final applicationVerified = data[0]['application_verified'];

                  return SizedBox(
                    height: size.height * 0.47,
                    child: (!applicationVerified)
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
                                      // provider.isCheckInformation = selected!;
                                      provider.setIsCheckInformation(userEmail, count, selected!);
                                      provider.getIsCheckInformation(userEmail, count);
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
                                      // provider.isCheckDocuments = selected!;
                                      provider.setIsCheckDocuments(userEmail, count, selected!);
                                      provider.getIsCheckDocuments(userEmail, count);
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
                                      // provider.isFinalCheck = selected!;
                                      provider.setIsFinalCheck(userEmail, count, selected!);
                                      provider.getIsFinalCheck(userEmail, count);
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
                                Center(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blackColor,
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
                                        if (provider.isCheckInformation ?? false) {
                                          provider.updateStatus(40, userEmail, count);
                                          provider.isCheckInformationToDatbase(userEmail, count);
                                        }

                                        if (provider.isCheckDocuments ?? false) {
                                          provider.updateStatus(70, userEmail, count);
                                          provider.isCheckDocumentsToDatbase(userEmail, count);
                                        }

                                        if (provider.isFinalCheck ?? false) {
                                          provider.updateStatus(100, userEmail, count);
                                          provider.isFinalCheckToDatbase(userEmail, count);
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
                                  ),
                                )),
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
                              Consumer<AppliacationCheckProvider>(builder: (context, provider, _) {
                                return Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        provider.pickFile(userEmail, count);
                                      },
                                      child: Text(
                                        'Upload Gst Certificate',
                                        style: AppStyle.poppinsBold12,
                                      ),
                                    ),
                                    Visibility(
                                      visible: provider.fileUploaded == true,
                                      child: Text('file Uploaded', style: AppStyle.poppinsBoldGreen12),
                                    ),
                                    Visibility(
                                      visible: provider.fileUploading == true,
                                      child: Text('file Uploading....', style: AppStyle.poppinsBold12),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    ElevatedButton(
                                      onPressed: () {
                                        appliCheckProvider.checkValidate(
                                          userEmail,
                                          gstNumberController.text.trim(),
                                          formKey,
                                          context,
                                          count,
                                        );

                                        gstNumberController.clear();

                                        provider.setFileUploaded = false;
                                      },
                                      child: Text(
                                        'Submit',
                                        style: AppStyle.poppinsBold12,
                                      ),
                                    ),
                                  ],
                                );
                              }),
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

  static GridView pdfView(BuildContext context, HashMap<String, File> documentFiles) {
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
        final String name = Provider.of<AppliacationCheckProvider>(context, listen: false).pdfsNames[index];

        final file = documentFiles[name]!;

        return InkWell(
          onTap: () {
            OpenFile.open(file.path);
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

Expanded rejectButton(BuildContext context, var userData, String email, int count) {
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

              value.notifyNotVerified(userData['Email'], count);
              // value.verificationStatusToTrue;
              setAcceptAcceptButtonTrue(email, count);
              Diologes.showSnackbar(context, 'Application Denied');
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

Expanded acceptButton(BuildContext context, var userData, String email, int count) {
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

              value.notifyVerified(userData['Email'], count);

              // value.verificationStatusToTrue;

              setAcceptAcceptButtonTrue(email, count);

              Diologes.showSnackbar(context, 'Application Accepted');

              // value.verificationStatusToFalse;
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

setAcceptAcceptButtonTrue(String email, int count) async {
  try {
    final QuerySnapshot<Object?> gstSnapshot = await APIs.accessGstDatabase(email, count);

    await gstSnapshot.docs.first.reference.update({
      'acceptbutton': true,
    });
  } catch (e) {
    log('error $e');
  }
}
