import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/dtos/requests/user/register_request.dart';
import 'package:foodapp/dtos/responses/api_response.dart';
import 'package:foodapp/dtos/responses/user/user.dart';
import 'package:foodapp/enums/popup_type.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/utils/utility.dart';
import 'package:foodapp/widgets/uibutton.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypedPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool rememberPassword = false;

  late UserService userService;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate;
    // Show showDatePicker for other platforms
    pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate ?? DateTime.now();
        dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate!); // Format the date
        // Calculate age
        int age = DateTime.now().difference(selectedDate!).inDays ~/ 365;
        // Check if age is less than 18
        if (age < 18) {
          Utility.alert(
            context: context,
            message: 'Age must be 18 or above.',
            popupType: PopupType.failure,
            onOkPressed: () {
              print('OK button pressed');
              // Additional actions can be added here
            },
          );

        }
      });
    }
  }

  @override
  void initState() {
    //33445566, pass: 123456789
    super.initState();
    //inject service
    userService = GetIt.instance<UserService>();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,//prevent exceed pixel when press textfield
            height: screenHeight,
            child: Stack(
              children: [
                Image(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                  width: screenWidth,
                  height: screenHeight,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Container(),),
                      Text('Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                      Expanded(child: Container(),),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: phoneNumberController, // Pass your TextEditingController here
                          decoration: InputDecoration(
                            hintText: 'Enter phone number', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.phone, // Set keyboard type to phone
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: emailController, // Pass your TextEditingController here
                          decoration: InputDecoration(
                            hintText: 'Enter email', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.emailAddress, // Set keyboard type to phone
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: fullNameController, // Pass your TextEditingController here
                          decoration: InputDecoration(
                            hintText: 'Enter fullName', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.phone, // Set keyboard type to phone
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: dobController,
                                enabled: false, // Disable editing
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                                  hintText: 'Select your DOB',
                                  border: InputBorder.none, // Remove border
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: passwordController, // Pass your TextEditingController here
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your password', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: retypedPasswordController, // Pass your TextEditingController here
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Retype your password', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(22), // Border radius
                          border: Border.all(
                            color: AppColors.primaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Address(optional)', // Placeholder text
                            border: InputBorder.none, // Remove default TextField border
                            contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding
                          ),
                          keyboardType: TextInputType.text, // Set keyboard type to phone
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Register',
                          textColor: Colors.white,
                          borderColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          onTap: () {
                            userService.register(
                                RegisterRequest(
                                  phoneNumber: phoneNumberController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  retypePassword: retypedPasswordController.text,
                                  dateOfBirth: selectedDate,
                                  fullName: fullNameController.text,
                                  address: addressController.text
                                )
                            ).then((ApiResponse response) {
                              Map<String, dynamic> data = response.data;
                              User user = User.fromJson(data);
                              // Navigate to login page
                              context.go("/login");
                            }).catchError((error) {
                              Utility.alert(
                                context: context,
                                message: error.message ?? '',
                                popupType: PopupType.info,
                                onOkPressed: () {
                                  // Additional actions can be added here
                                },
                              );

                            });
                          }
                          ,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Login');
                          context.go("/login");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Have account ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' Login',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container(),),
                      Expanded(child: Container(),),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
