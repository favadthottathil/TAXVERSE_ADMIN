import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/utils/diologes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'widgets/application_check_wigets/application_check_widgets.dart';

class VerifyApplication extends StatefulWidget {
  VerifyApplication({super.key, required this.gstdata, required this.userData});

  final DocumentSnapshot gstdata;

  final DocumentSnapshot userData;

  @override
  State<VerifyApplication> createState() => _VerifyApplicationState();
}

class _VerifyApplicationState extends State<VerifyApplication> {
  // NotificationServices notificationService = NotificationServices();

  final percentageController = TextEditingController();

  final gstNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // clientName = userData['Name'];
    final aadhaarpdf = widget.gstdata['AADHAARCARD'];
    final buildingTaxPdf = widget.gstdata['BUILDING TAX RECEIPT'];
    final electricitybillPdf = widget.gstdata['Electricity bill'];
    final panCardPdf = widget.gstdata['PANCARD'];
    final rentAgreementPdf = widget.gstdata['RENT AGREEMENT'];
    Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs.add(aadhaarpdf);
    Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs.add(buildingTaxPdf);
    Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs.add(electricitybillPdf);
    Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs.add(panCardPdf);
    Provider.of<AppliacationCheckProvider>(context, listen: false).pdfs.add(rentAgreementPdf);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Verify Application',
                  textAlign: TextAlign.left,
                  style: AppStyle.poppinsBold27,
                ),
                SizedBox(height: size.height * 0.01, width: size.width * 0.2),
                Text(
                  'Service: ${widget.gstdata['ServiceName']}',
                  textAlign: TextAlign.left,
                  style: AppStyle.poppinsBold16,
                ),
                SizedBox(height: size.height * 0.01, width: size.width * 0.2),
                Text(
                  "Client Details",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.poppinsBold16,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['name'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: 30,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['BusinessName'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['BusinesssType'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['BusinessStartDate'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        child: CachedNetworkImage(
                          imageUrl: widget.gstdata['PassportSizePhoto'],
                          placeholder: (context, url) => const SpinKitThreeBounce(color: blackColor),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['PanCardNumber'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['AadhaarCard'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                sizedBoxHeight20,
                Row(
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
                        widget.gstdata['BusinessRegistrationNumber'],
                        textAlign: TextAlign.left,
                        style: AppStyle.poppinsBold16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: blackColor.withOpacity(0.1),
                  thickness: 1,
                  height: size.height * 0.04,
                ),
                Text('Client Documents', style: AppStyle.poppinsBold16),
                sizedBoxHeight20,
                ApplicationCheckWidgets.pdfView(context),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      ApplicationCheckWidgets.customDialog(
                        context,
                        size,
                        widget.gstdata['Email'],
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
                if (Provider.of<AppliacationCheckProvider>(context, listen: false).verificatinStatus == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rejectButton(context),
                      const SizedBox(width: 30),
                      acceptButton(context)
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded rejectButton(BuildContext context) {
    return Expanded(
      child: InkWell(
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
                widget.userData['message_token'],
                'your Application Denied',
                'Denied',
              );
              Diologes.showSnackbar(context, 'Application Denied');
              Provider.of<AppliacationCheckProvider>(context, listen: false).notifyNotVerified(widget.userData['Email']);
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
      ),
    );
  }

  Expanded acceptButton(BuildContext context) {
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
                  widget.userData['message_token'],
                  'your Application Successfully verified',
                  'Application verified',
                );
                Diologes.showSnackbar(context, 'Application Accepted');

                Provider.of<AppliacationCheckProvider>(context, listen: false).notifyVerified(widget.userData['Email']);

                value.verificationStatusToTrue();
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
}
