import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/auth_provider.dart';
import 'package:taxverse_admin/view/application_more.dart';
import 'package:taxverse_admin/view/widgets/appointment_request_home.dart';

// ignore: must_be_immutable
class HomeAdmin extends StatelessWidget {
  HomeAdmin({super.key});

  NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MessagingAPI.getFirebaseMessagingToken();

      notificationServices.firebaseInit();
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: APIs.clientdataCollection,
          builder: (context, snapshot1) {
            var gstData = snapshot1.data?.docs ?? [];
            if (snapshot1.connectionState == ConnectionState.active) {

              return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.07),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Welcome Admin...',
                                    textAlign: TextAlign.left,
                                    style: AppStyle.poppinsBold27,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.question,
                                        animType: AnimType.scale,
                                        showCloseIcon: true,
                                        title: 'Logout',
                                        desc: 'Do You want to Logout From this Account',
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
                                          context.read<AuthProviderr>().logOut(context);
                                        },
                                        buttonsBorderRadius: BorderRadius.circular(20),
                                      ).show();
                                    },
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Application',
                                  textAlign: TextAlign.left,
                                  style: AppStyle.poppinsBold16,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApplicationMore(),
                                    ),
                                  ),
                                  child: Text(
                                    'more',
                                    textAlign: TextAlign.right,
                                    style: AppStyle.poppinsRegular16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            SizedBox(
                              width: double.infinity,
                              child: gstData.isEmpty
                                  ? SizedBox(
                                      // color: Colors.amber,
                                      height: size.height * 0.2,
                                      width: size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'NO Application Found !!!',
                                            style: AppStyle.poppinsBold20,
                                          ),
                                        ],
                                      ),
                                    )
                                  : applicationList(gstData),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Appointment Requests',
                              textAlign: TextAlign.left,
                              style: AppStyle.poppinsBold16,
                            ),
                            const SizedBox(height: 20),
                            const AppoinmentRequestHome(),
                          ],
                        ),
                      ),
                    );
              
            } else if (snapshot1.hasError) {
              return Center(
                child: Text('Error to fetch Data ${snapshot1.error}'),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
