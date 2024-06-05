import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplier_multi_store_app/widgets/appbar_widgets.dart';
import 'package:supplier_multi_store_app/widgets/snack_bar.dart';
import 'package:supplier_multi_store_app/widgets/yellow_button.dart';

class EditStoreScreen extends StatefulWidget {
  final dynamic data;
  const EditStoreScreen({super.key, required this.data});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  XFile? _imageLogoFile;
  XFile? _imageCoverFile;
  dynamic _pickedImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool processing = false;

  pickStoreLogo() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageLogoFile = pickedImage;
      });
    } catch (error) {
      setState(() {
        _pickedImageError = error;
      });
      print(_pickedImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedCoverImage = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageCoverFile = pickedCoverImage;
      });
    } catch (error) {
      setState(() {
        _pickedImageError = error;
      });
      print(_pickedImageError);
    }
  }

  onSaved() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); //continue
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async =>
          uploadCoverImage().whenComplete(() async => await editStoreData()));
    } else {
      MyMessageHandler.showSnackBar(
          _scaffoldMessengerKey, 'Pleae fill all fields');
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'store_name': storeName,
        'phone': phone,
        'store_logo': storeLogo,
        'cover_image': coverImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  Future<void> uploadStoreLogo() async {
    if (_imageLogoFile != null) {
      try {
        Reference ref = await FirebaseStorage.instance
            .ref('suppliers_images/${widget.data['email']}.jpg-cover');
        await ref.putFile(File(_imageLogoFile!.path));
        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['store_logo'];
    }
  }

  Future<void> uploadCoverImage() async {
    if (_imageCoverFile != null) {
      try {
        Reference ref2 = await FirebaseStorage.instance
            .ref('suppliers_images/${widget.data['email']}.jpg');
        await ref2.putFile(File(_imageCoverFile!.path));
        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['cover_image'];
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppbarBackButton(),
          title: const AppbarTitle(
            title: 'Edit Store',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Store Logo',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(widget.data['store_logo']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                                label: 'Change',
                                onPressed: () {
                                  pickStoreLogo();
                                },
                                widthInPercent: 0.3),
                            _imageLogoFile == null
                                ? const SizedBox()
                                : const SizedBox(
                                    height: 20,
                                  ),
                            _imageLogoFile == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        _imageLogoFile = null;
                                      });
                                    },
                                    widthInPercent: 0.3),
                          ],
                        ),
                        _imageLogoFile == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    FileImage(File(_imageLogoFile!.path)),
                              ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 2,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Cover Image',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(widget.data['cover_image']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                                label: 'Change',
                                onPressed: () {
                                  pickCoverImage();
                                },
                                widthInPercent: 0.3),
                            _imageCoverFile == null
                                ? const SizedBox()
                                : const SizedBox(
                                    height: 20,
                                  ),
                            _imageCoverFile == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        _imageCoverFile = null;
                                      });
                                    },
                                    widthInPercent: 0.3),
                          ],
                        ),
                        _imageCoverFile == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    FileImage(File(_imageCoverFile!.path)),
                              ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 2,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      storeName = newValue!;
                    },
                    initialValue: widget.data['store_name'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Store Name', hintText: 'Enter store name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      phone = newValue!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Phone Number',
                        hintText: 'Enter yout phone number'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    YellowButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        widthInPercent: 0.3),
                    processing
                        ? YellowButton(
                            label: 'Please Wait..',
                            onPressed: () {
                              null;
                            },
                            widthInPercent: 0.5)
                        : YellowButton(
                            label: 'Save Changes',
                            onPressed: () {
                              onSaved();
                            },
                            widthInPercent: 0.5)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.purple),
  hintText: 'Price...',
  labelText: 'Price',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.yellow)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
);
