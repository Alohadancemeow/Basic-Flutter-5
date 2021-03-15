import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:register_form_app/models/profile.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // ! Field Variables
  final _formKey = GlobalKey<FormState>();
  Profile _profile = Profile();

  // Firebase reference
  CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection("profiles");
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final ImagePicker _imagePicker = ImagePicker();
  File _selectedImageFile;

  //imgaePicker will return pickedFile
  getImage() async {
    final selectedFile =
        await _imagePicker.getImage(source: ImageSource.gallery);
    print('${selectedFile.path}');

    setState(() {
      //parse PickedFile to File
      _selectedImageFile = File(selectedFile.path);
    });
  }

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
                        //call getImage
                        getImage();

                        print('open camera');
                      },
                      //show image
                      child: _selectedImageFile != null
                          ? Image.file(_selectedImageFile)
                          : Container(
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
                    child: Text('Register'),
                    onPressed: () async {
                      print('register clicked');

                      if (_formKey.currentState.validate()) {
                        //saved text
                        _formKey.currentState.save();
                        print(
                            "${_profile.firstName} ${_profile.lastName} ${_profile.email}");

                        //show dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Uploading...")
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        //add imageFile to storage
                        if (_selectedImageFile != null) {
                          //get path
                          String fileName = basename(_selectedImageFile.path);
                          _firebaseStorage
                              .ref()
                              .child('images/$fileName')
                              .putFile(_selectedImageFile);

                          print('image uploaded');
                        }

                        //add data to firestore.
                        await _profileCollection.add({
                          'first_name': _profile.firstName,
                          'last_name': _profile.lastName,
                          'email': _profile.email,
                          'image_ref': basename(_selectedImageFile.path)
                        });

                        //pop dialog out
                        Navigator.pop(context);

                        //reset form field
                        _formKey.currentState.reset();

                        //reset image file
                        setState(() {
                          _selectedImageFile = null;
                        });
                      }
                    },
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
