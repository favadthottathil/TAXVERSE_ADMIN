import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/auth_provider.dart';
import 'package:taxverse_admin/view/bottom_nav.dart';
import 'package:taxverse_admin/view/sign_up.dart';
import 'package:taxverse_admin/view/widgets/frosted_glass.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool isSigned = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // Validate Email

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(email)) {
      return 'Enter a valid Email';
    }
    return null;
  }

  // Firebase SignIn

  void signIn(AuthProviderr provider) async {
    final msg = await provider.signIn(emailController.text, passController.text);

    emailController.clear();
    passController.clear();

    if (msg == '') return;

    ScaffoldMessenger.of(scaffoldKey.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: context.watch<AuthProviderr>().stream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const BottomNav();

        final mediaQuery = MediaQuery.of(context);
        final authprovider = context.watch<AuthProviderr>();

        return Scaffold(
          body: SafeArea(
            child: Form(
              key: formkey,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: mediaQuery.size.height * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.asset(
                            'Asset/TAXVERSE LOGO-1.png',
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // const SizedBox(height: 20),
                          Text(
                            'Admin Login',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              // color: blackColor,
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.03),
                          SizedBox(
                            width: mediaQuery.size.width * 0.64,
                            height: mediaQuery.size.height * 0.22,
                            child: Image.asset(
                              'Asset/sign_in.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.03),
                          emaiTextField(),
                          Container(
                            height: mediaQuery.size.height * 0.03,
                          ),
                          passwordTextField(),
                          Container(
                            height: mediaQuery.size.height * 0.02,
                          ),

                          SizedBox(
                            height: mediaQuery.size.height * 0.03,
                          ),
                          signInButton(authprovider, mediaQuery),
                          SizedBox(
                            height: mediaQuery.size.height * 0.01,
                          ),
                          gotoSignUp(context),
                        ],
                      ),
                    ],
                  ),
                  if (authprovider.loading)
                    const Center(
                      child: FrostedGlass(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: SpinKitCircle(
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell gotoSignUp(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUp(),
            ));
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Color(0xa0000000),
          ),
          children: [
            TextSpan(
              text: 'Don’t have a account?',
              style: GoogleFonts.poppins(),
            ),
            TextSpan(
              text: ' Sign Up',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: const Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell signInButton(AuthProviderr authprovider, MediaQueryData mediaQuery) {
    return InkWell(
      onTap: () {
        signIn(authprovider);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        width: double.infinity,
        height: 0.088 * mediaQuery.size.height,
        decoration: BoxDecoration(
          color: const Color(0xff000000),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Padding passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: TextFormField(
          controller: passController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (pass) => pass != null && pass.length < 6 ? 'Enter min 6 Characters' : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            border: InputBorder.none,
            filled: true,
            // fillColor: whiteColor,
            hintText: 'Enter Your password',
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xa0000000),
            ),
          ),
        ),
      ),
    );
  }

  Column emaiTextField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TextFormField(
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: const Color(0xa0000000),
              ),
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateEmail,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                border: InputBorder.none,
                filled: true,
                // fillColor: whiteColor,
                hintText: 'Enter Your email',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: const Color(0xa0000000),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
