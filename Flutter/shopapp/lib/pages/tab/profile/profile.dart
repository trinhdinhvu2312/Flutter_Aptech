import 'package:flutter/material.dart';
import 'package:foodapp/dtos/responses/user/user.dart';
import 'package:foodapp/pages/app_routes.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/widgets/loading.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserService userService;
  late Future<User> _userDetailsFuture;
  @override
  void initState() {
    super.initState();
    userService = GetIt.instance<UserService>();
    _userDetailsFuture = userService.getUserDetails();
  }
  void _refreshUserDetails() {
    setState(() {
      _userDetailsFuture = userService.getUserDetails();
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final User user = snapshot.data!;
          print(user.profileImage);
          return ListView(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: AppColors.primaryColor,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                      ),
                    ),
                    SizedBox(height: 10),
                    //{{API_PREFIX}}users/profile-images/default-profile-image.jpeg
                    //              users/profile-images/default-profile-image.jpeg
                    Text(
                      user.fullName ?? 'Username',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email: ${user.email}', style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone Number: ${user.phoneNumber}', style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Address: ${user.address ?? 'Not provided'}', style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Date of Birth: ${user.dateOfBirth?.toString().substring(0, 10) ?? 'Not provided'}', style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Password', style: Theme.of(context).textTheme.bodyMedium),
                subtitle: Text('********', style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  // Navigate to the change password page
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Signout', style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  userService.logout();
                  context.go('/${AppRoutes.login}');
                },
              ),
            ],
          );
        }
      },
    );
  }
  // Method to pick image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // You can also use ImageSource.camera
    if (pickedFile != null) {
      try {
        String imageName = await userService.uploadImage(pickedFile.path);
        print(imageName); // Corrected print statement
        _refreshUserDetails();
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print("Image picking was canceled by the user.");
    }
  }

}
