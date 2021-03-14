import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:register_form_app/models/profile.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // ! Field Variables
  final _formKey = GlobalKey<FormState>();
  Profile _profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,

          // ! Scrollable
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Firstname'),
                TextFormField(
                  //use form field validator package.
                  validator:
                      RequiredValidator(errorText: 'Please enter your name'),
                  //get text
                  onSaved: (String firstName) {
                    _profile.firstName = firstName;
                  },
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                Text('Lastname'),
                TextFormField(
                  //validateor
                  validator: RequiredValidator(
                      errorText: 'Please enter your lastname'),
                  //get text
                  onSaved: (String lastName) {
                    _profile.lastName = lastName;
                  },
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                Text('Email'),
                TextFormField(
                  //multivalidateor
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your email'),
                    EmailValidator(errorText: 'Invalid email'),
                  ]),
                  //get text
                  onSaved: (String email) {
                    _profile.email = email;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                Text('Images'),

                // ! image area
                Container(
                  padding: EdgeInsets.all(10),
                  child: Ink(
                    color: Colors.grey[300],
                    child: InkWell(
                      onTap: () {
                        print('open camera');
                      },
                      child: Container(
                        height: 150,
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // ! Button area
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      print('register clicked');

                      if (_formKey.currentState.validate()) {
                        //saved text
                        _formKey.currentState.save();
                        print(
                            "${_profile.firstName} ${_profile.lastName} ${_profile.email}");
                      }
                    },
                    child: Text('Register'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
