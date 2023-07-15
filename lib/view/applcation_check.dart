
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'widgets/application_check_wigets/application_check_widgets.dart';

class VerifyApplication extends StatelessWidget {
  VerifyApplication({super.key, required this.gstdata, required this.userData});

  final DocumentSnapshot gstdata;

  final DocumentSnapshot userData;

  // NotificationServices notificationService = NotificationServices();
  final percentageController = TextEditingController();

  final gstNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // clientName = userData['Name'];
    final aadhaarpdf = gstdata['AADHAARCARD'];
    final buildingTaxPdf = gstdata['BUILDING TAX RECEIPT'];
    final electricitybillPdf = gstdata['Electricity bill'];
    final panCardPdf = gstdata['PANCARD'];
    final rentAgreementPdf = gstdata['RENT AGREEMENT'];
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
                clientPhotoRow(size),
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
                ApplicationCheckWidgets.pdfView(context),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      ApplicationCheckWidgets.customDialog(
                        context,
                        size,
                        gstdata['Email'],
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
                    rejectButton(context,userData),
                    const SizedBox(width: 30),
                    acceptButton(context,userData)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                      gstdata['BusinessRegistrationNumber'],
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
                      gstdata['AadhaarCard'],
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
                      gstdata['PanCardNumber'],
                      textAlign: TextAlign.left,
                      style: AppStyle.poppinsBold16,
                    ),
                  ),
                ],
              );
  }

  Row clientPhotoRow(Size size) {
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
                      child: CachedNetworkImage(
                        imageUrl: gstdata['PassportSizePhoto'],
                        placeholder: (context, url) => const SpinKitThreeBounce(color: blackColor),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
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
                      gstdata['BusinessStartDate'],
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
                      gstdata['BusinesssType'],
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
                      gstdata['BusinessName'],
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
                      gstdata['name'],
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


}
