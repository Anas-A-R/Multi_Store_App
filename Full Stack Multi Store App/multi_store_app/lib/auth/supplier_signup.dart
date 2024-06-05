// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/providers/auth_repo.dart';
import 'package:multi_store_app/widgets/auth_wodgets.dart';
import 'package:multi_store_app/widgets/snack_bar.dart';

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({super.key});

  @override
  State<SupplierRegister> createState() => SupplierRegisterState();
}

class SupplierRegisterState extends State<SupplierRegister> {
  late String storeName;
  late String email;
  late String password;
  late String _uid;
  late String storeLogo;
  bool paswordVisibe = false;
  bool processing = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  XFile? _imageFile;
  dynamic _pickedImageError;
  final ImagePicker _imagePicker = ImagePicker();
  void pickImageFromCamera() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (error) {
      setState(() {
        _pickedImageError = error;
      });
      print(_pickedImageError);
    }
  }

  void pickImageFromGallery() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (error) {
      setState(() {
        _pickedImageError = error;
      });
      print(_pickedImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formkey.currentState!.validate()) {
      if (_imageFile == null) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldMessengerKey, 'Please pick an image first');
      } else {
        try {
          await AuthRepo.signUpWithEmailAndPassword(email, password);
          AuthRepo.sendEmailVerification();

          // storing image
          _uid = AuthRepo.uid;
          Reference ref =
              FirebaseStorage.instance.ref('supplier_images/$email.jpg');
          await ref.putFile(File(_imageFile!.path));

          storeLogo = await ref.getDownloadURL();
          AuthRepo.updateUserName(storeName);
          AuthRepo.updateStoreLogo(storeLogo);
          //storing user info
          await FirebaseFirestore.instance
              .collection('suppliers')
              .doc(_uid)
              .set({
            'store_name': storeName,
            'email': email,
            'store_logo': storeLogo,
            'address': '',
            'phone': '',
            'sid': _uid,
            'password': password,
            'cover_image': '',
          });
          Navigator.pushReplacementNamed(context, '/supplier_login');
          _formkey.currentState!.reset(); //reset all fields
          setState(() {
            _imageFile = null;
          });
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              _scaffoldMessengerKey, e.message.toString());
        }
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(
          _scaffoldMessengerKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(
                        label: ' S Sign Up',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CircleAvatar(
                              backgroundColor: Colors.purpleAccent,
                              radius: 50,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: IconButton(
                                    onPressed: () {
                                      pickImageFromCamera();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: IconButton(
                                    onPressed: () {
                                      pickImageFromGallery();
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            onChanged: (value) {
                              storeName = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your store name.';
                              }
                              return null;
                            },
                            decoration: textFormDecoration.copyWith(
                                label: const Text('Store name'),
                                hintText: 'Enter your store name')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email.';
                            } else if (value.isValidateEmail() == false) {
                              return 'Invalid email';
                            } else if (value.isValidateEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              label: const Text('Email'),
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          obscureText: paswordVisibe,
                          decoration: textFormDecoration.copyWith(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      paswordVisibe = !paswordVisibe;
                                    });
                                  },
                                  icon: Icon(
                                    paswordVisibe
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.purple,
                                  )),
                              label: const Text('Password'),
                              hintText: 'Enter your password'),
                        ),
                      ),
                      HaveAccount(
                        actionLabel: 'Login',
                        onpressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_login');
                        },
                        haveAccount: 'Already have an account?',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      processing
                          ? const CircularProgressIndicator()
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: signUp,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidateEmail() {
    return RegExp(
            r'^([a-zA-Z0-9])([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        ///////(anas       )(optional )(razaq850    )(@  )(gmail          )(.   com          )
        .hasMatch(this);
  }
}
