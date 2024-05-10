import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/dtos/requests/user/login_request.dart';
import 'package:foodapp/enums/popup_type.dart';
import 'package:foodapp/pages/app_routes.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/utils/utility.dart';
import 'package:foodapp/utils/validations.dart';
import 'package:foodapp/widgets/uibutton.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Create an alias FirebaseUser for User
typedef FirebaseUser = User;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class _LoginState extends State<Login> {
  final emailOrPhoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberPassword = false;
  late UserService userService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    //33445566, pass: 123456789
    super.initState();
    //inject service
    userService = GetIt.instance<UserService>();
    // Retrieve credentials
    userService.getCredentials().then((credentials) {
      //promise
      emailOrPhoneNumberController.text = credentials['phoneNumber'] ?? '';
      passwordController.text = credentials['password'] ?? '';
    });
    _firebaseAuth.authStateChanges()
        .listen((FirebaseUser? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print('screenWidth = ${screenWidth}, screenHeight = ${screenHeight}');
    return Scaffold(
      body: SingleChildScrollView(  // Wrapping with SingleChildScrollView
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
              width: screenWidth,
              height: screenHeight,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.2), // Adjusted space
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  SizedBox(height: 20),
                  loginTextField(
                      hint: 'Enter phone number or email',
                      controller: emailOrPhoneNumberController,
                      isObscure: false
                  ),
                  SizedBox(height: 20),
                  loginTextField(
                      hint: 'Enter your password',
                      controller: passwordController,
                      isObscure: true
                  ),
                  rememberPasswordRow(),
                  loginButton('Login'),
                  registerRow(),
                  socialLoginButtons(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loginTextField({
    required String hint,
    required TextEditingController controller,
    required bool isObscure,
  }) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
        keyboardType: isObscure ? TextInputType.text : TextInputType.emailAddress,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
  Widget registerRow() {
    return GestureDetector(
      onTap: () {
        print('Register');
        context.go('/${AppRoutes.register}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do not have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' Register',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget rememberPasswordRow() {
    return InkWell(
      onTap: () {
        setState(() {
          rememberPassword = !rememberPassword;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, right: 5, bottom: 10),
            child: Icon(
              rememberPassword ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 5),
          Text(
            'Remember password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Widget socialLoginButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        socialButton(
          text: "Google",
          icon: Icons.account_circle,
          color: Colors.red,
          onTap: () async {
            try {
              // Attempt to sign in with Google.
              UserCredential userCredential = await signInWithGoogle();

              // Check if the user successfully signed in.
              if (userCredential.user != null) {
                FirebaseUser user = userCredential.user!;
                String displayName = user.displayName ?? '';
                String email = user.email ?? '';
                String photoURL = user.photoURL ?? '';
                String phoneNumber = user.phoneNumber ?? '';
                String uid = user.uid;
                // Navigate to AppTab only if sign-in is successful.
                context.go('/${AppRoutes.appTab}');
              } else {
                // Handle the situation where the user is not returned.
                print("Sign-in failed: No user returned.");
              }
            } catch (e) {
              // Handle any errors that occur during sign-in.
              print("Sign-in error: $e");
            }
          },

        ),
        SizedBox(width: 10),
        socialButton(
          text: "Facebook",
          icon: Icons.facebook,
          color: Colors.blue,
          onTap: () {
            print("Facebook login tapped");
          },
        )
        ],
      ),
    );
  }

  Widget socialButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 6),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
  Widget loginButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Login',
        textColor: Colors.white,
        borderColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        onTap: () async {
          print('Login');
          String input = emailOrPhoneNumberController.text;
          String password = passwordController.text;

          if (Validations.isValidEmail(input)) {
            await userService.login(
                LoginRequest(email: input, password: password));
            await loginToFirebaseWithEmaiAndlPassword(
                email: input,
                password: password,
                context: context
            );
          } else if (Validations.isValidPhoneNumber(input)) {
            await userService.login(LoginRequest(phoneNumber: input, password: password));
            await loginToFirebaseWithPhone(phoneNumber: input, context: context);
          } else {
            Utility.alert(
              context: context,
              message: 'Invalid phone number or email',
              popupType: PopupType.failure,
              onOkPressed: () {
                print('OK button pressed');
                // Perform any other actions here
              },
            );
          }
          if (rememberPassword == true) {
            await userService.saveCredentials(
                phoneNumber: emailOrPhoneNumberController.text,
                password: passwordController.text);
          }
          context.go('/${AppRoutes.appTab}');
          ;
        },
      ),
    );
  }
  Future<void> loginToFirebaseWithEmaiAndlPassword({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Firebase login successful!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utility.alert(
            context: context,
            message: 'The password provided is too weak.',
            popupType: PopupType.failure,
            onOkPressed: () => print('OK button pressed')
        );
      } else if (e.code == 'email-already-in-use') {
        Utility.alert(
            context: context,
            message: 'The email address is already in use by another account.',
            popupType: PopupType.failure,
            onOkPressed: () async {
              // Attempt to sign in instead of creating a new account
              try {
                await _firebaseAuth.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print("Signed in with existing account.");
              } catch (e) {
                Utility.alert(
                    context: context,
                    message: 'Failed to sign in with existing account: ${e.toString()}',
                    popupType: PopupType.failure,
                    onOkPressed: () => print('OK button pressed')
                );
              }
            }
        );
      }
    } catch (e) {
      Utility.alert(
          context: context,
          message: 'An unexpected error occurred: ${e.toString()}',
          popupType: PopupType.failure,
          onOkPressed: () => print('OK button pressed')
      );
    }
  }
  Future<void> loginToFirebaseWithPhone({
    required String phoneNumber,
    required BuildContext context
  }) async {
    // Trigger the verification process
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android only: Firebase automatically signs in when verification is completed
          try {
            final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
            print("Phone authentication successful!");
            // Optionally notify user with a success message
          } catch (e) {
            Utility.alert(
                context: context,
                message: 'An error occurred while signing in: ${e.toString()}',
                popupType: PopupType.failure,
                onOkPressed: () => print('OK button pressed')
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle the error if verification fails
          Utility.alert(
              context: context,
              message: 'Verification failed: ${e.message}',
              popupType: PopupType.failure,
              onOkPressed: () => print('OK button pressed')
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // This callback is called when the verification code has been sent to the user
          // Display a dialog to the user to enter the OTP
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Enter OTP'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      // Store the entered OTP
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () async {
                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: '123456'); // Assume '123456' is the code entered by the user
                    try {
                      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
                      print("Phone OTP verification successful!");
                      Navigator.pop(context); // Close the dialog
                    } catch (e) {
                      Navigator.pop(context); // Close the dialog
                      Utility.alert(
                          context: context,
                          message: 'Failed to sign in: ${e.toString()}',
                          popupType: PopupType.failure,
                          onOkPressed: () => print('OK button pressed')
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        }
    );
  }
}
