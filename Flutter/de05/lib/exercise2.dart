import 'package:flutter/material.dart';
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = "";
  String _email = "";
  String _phoneNumber = "";
  String _errorMessage = "";

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      // Process registration data (e.g., send to a server)
      setState(() {
        _errorMessage = "Registration successful!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
                validator: (value) {
                  if (value!.length < 5) {
                    return "Full name must be at least 5 characters";
                  }
                  return null;
                },
                onSaved: (newValue) => _fullName = newValue!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$").hasMatch(value!)) {
                    return "Invalid email format";
                  }
                  return null;
                },
                onSaved: (newValue) => _email = newValue!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone Number",
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (RegExp(r"[^\d]").hasMatch(value!)) {
                    return "Phone number must only contain numbers";
                  }
                  return null;
                },
                onSaved: (newValue) => _phoneNumber = newValue!,
              ),
              ElevatedButton(
                onPressed: _handleRegistration,
                child: Text("Register"),
              ),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}