import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/Api/messaging_api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/auth_provider.dart';
import 'package:taxverse_admin/view/applcation_check.dart';
import 'package:taxverse_admin/view/application_more.dart';
import 'package:taxverse_admin/view/widgets/appointment_request_home.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final clientdataCollection = FirebaseFirestore.instance
      .collection('ClientGstInfo')
      .orderBy(
        'time',
        descending: false,
      )
      .snapshots();

  final userData = FirebaseFirestore.instance.collection('ClientDetails').orderBy('time', descending: false).snapshots();

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    MessagingAPI.getFirebaseMessagingToken();

    notificationServices.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: clientdataCollection,
          builder: (context, snapshot1) {
            if (snapshot1.connectionState == ConnectionState.active) {
              return StreamBuilder(
                stream: userData,
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.active) {
                    var gstData = snapshot1.data?.docs ?? [];

                    var userData = snapshot2.data?.docs ?? [];

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 41),
                              child: Text(
                                'Welcome Admin...',
                                textAlign: TextAlign.left,
                                style: AppStyle.poppinsBold27,
                              ),
                            ),
                            const SizedBox(height: 19),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: const Color(0xa0000000),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Search Clients',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: const Color(0xa0000000),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 14, width: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: gstData.length > 3 ? 3 : gstData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VerifyApplication(
                                              gstdata: gstData[index],
                                              userData: userData[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: blackColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(45),
                                                child: Image.asset(
                                                  'Asset/3135715.png',
                                                  height: 90,
                                                  width: 90,
                                                ),
                                              ),
                                              const SizedBox(width: 25),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Name: ',
                                                              style: AppStyle.poppinsRegular16,
                                                            ),
                                                            TextSpan(
                                                              text: userData[index]['Name'],
                                                              style: AppStyle.poppinsBold16,
                                                            )
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Service: ',
                                                              style: AppStyle.poppinsRegular16,
                                                            ),
                                                            TextSpan(
                                                              text: gstData[index]['ServiceName'],
                                                              style: AppStyle.poppinsBold16,
                                                            )
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Status: ',
                                                              style: AppStyle.poppinsRegular16,
                                                            ),
                                                            TextSpan(
                                                              text: gstData[index]['status'],
                                                              style: AppStyle.poppinsBold16,
                                                            )
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                  }
                  return Container();
                },
              );
            } else if (snapshot1.hasError) {
              return Center(
                child: Text('Error to fetch Data ${snapshot1.error}'),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  myHeaderDrawer(),
                  InkWell(
                    onTap: () {
                      context.read<AuthProvider>().logOut(context);
                    },
                    child: myDrawerList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget myHeaderDrawer() {
  return Container(
    color: whiteColor,
    height: 200,
    width: double.infinity,
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 70,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
        ),
        Text(
          'admin124@gmail.com',
          style: AppStyle.poppinsBold16,
        )
      ],
    ),
  );
}

Widget myDrawerList() {
  return Container(
    padding: const EdgeInsets.only(top: 15),
    child: Column(
      children: [
        menuItem(text: 'Logout', icon: Icons.logout),
      ],
    ),
  );
}

Widget menuItem({required String text, required IconData icon}) {
  return Material(
    child: Row(
      children: [
        Expanded(
          child: Icon(
            icon,
            size: 20,
            color: blackColor,
          ),
        ),
        Expanded(
            flex: 3,
            child: Text(
              text,
              style: AppStyle.poppinsRegular16,
            ))
      ],
    ),
  );
}
