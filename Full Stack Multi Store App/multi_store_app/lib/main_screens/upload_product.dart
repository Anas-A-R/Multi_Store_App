// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snack_bar.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  late String name;
  late double price;
  late int quantity;
  late String description;
  late String productId;
  int? discont = 0;
  bool processing = false;
  String subCategoryValue = 'subcategory';
  String mainCategoryValue = 'select category';
  List subCategList = [];
  List<String> imageUrlList = [];
  List<XFile>? imagesFileList = [];

  dynamic _pickedImageError;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //

  void pickProductImages() async {
    try {
      final pickedImages = await _imagePicker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (error) {
      setState(() {
        _pickedImageError = error;
      });
      print(_pickedImageError);
    }
  }

  void selectedMainCategory(String? value) {
    setState(() {
      mainCategoryValue = value!;
      subCategoryValue = 'subcategory';
    });
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
  }

  Future<void> uploadImages() async {
    if (mainCategoryValue != 'select category' &&
        subCategoryValue != 'sub category') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!
            .save(); //save all data because we are using onSaved function in the text field
        if (imagesFileList!.isEmpty) {
          MyMessageHandler.showSnackBar(
              _scaffoldMessengerKey, 'Please pick images first');
        } else {
          if (imagesFileList!.isNotEmpty) {
            setState(() {
              processing = true;
            });
            try {
              for (var image in imagesFileList!) {
                Reference ref = FirebaseStorage.instance
                    .ref('products/${path.basename(image.path)}');

                await ref.putFile(File(image.path)).whenComplete(() async {
                  await ref.getDownloadURL().then((value) {
                    imageUrlList.add(value);
                  });
                });
              }
            } catch (error) {
              print(error);
            }
          }
        }
      } else {
        MyMessageHandler.showSnackBar(
            _scaffoldMessengerKey, 'Please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(
          _scaffoldMessengerKey, 'Please select categories first');
    }
  }

  Future<void> uploadData() async {
    if (imageUrlList.isNotEmpty) {
      productId = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set({
        'product_id': productId,
        'product_name': name,
        'product_description': description,
        'product_price': price,
        'product_instoke': quantity,
        'product_mainCategory': mainCategoryValue,
        'product_subCategory': subCategoryValue,
        'product_images': imageUrlList,
        'product_discount': discont,
        'supplier_id': FirebaseAuth.instance.currentUser!.uid,
      }).whenComplete(() {
        //clear all data
        setState(() {
          processing = false;
          imagesFileList!.clear();
          mainCategoryValue = 'select category';
          subCategoryValue = 'subcategory';
          // subCategList.clear();
          imageUrlList.clear();
        });
        _formKey.currentState!.reset();
      });
    } else {
      print('no image selected');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  Widget previewImages() {
    return ListView.builder(
      itemCount: imagesFileList!.length,
      itemBuilder: (context, index) {
        return Image.file(File(imagesFileList![index].path));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //images container
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.blueGrey.shade100,
                      child: imagesFileList!.isNotEmpty
                          ? previewImages()
                          : const Text(
                              'You don\'t have \n\nselect an image yet!',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    //drop down lists
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //main category dropdown
                          Column(
                            children: [
                              const Text(' * Select main category',
                                  style: TextStyle(color: Colors.red)),
                              DropdownButton(
                                iconSize: 40,
                                iconEnabledColor: Colors.red,
                                menuMaxHeight: 500,
                                iconDisabledColor: Colors.black,
                                dropdownColor: Colors.yellow.shade400,
                                value: mainCategoryValue,
                                items: maincateg
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedMainCategory(value);
                                },
                              ),
                            ],
                          ),
                          //sub category dropdown
                          Column(
                            children: [
                              const Text(' * Select subcategory',
                                  style: TextStyle(color: Colors.red)),
                              DropdownButton(
                                menuMaxHeight: 500,
                                iconDisabledColor: Colors.black,
                                iconSize: 40,
                                iconEnabledColor: Colors.red,
                                dropdownColor: Colors.yellow.shade400,
                                disabledHint: const Text('select subcategory'),
                                value: subCategoryValue,
                                items: subCategList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    subCategoryValue = value!;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                  color: Colors.yellow,
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: TextFormField(
                            onSaved: (newValue) {
                              price = double.parse(newValue!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter price';
                              } else if (value.isValidatePrice() != true) {
                                return 'Invalid price';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration.copyWith(
                              hintText: 'Price .. \$',
                              labelText: 'Price',
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: TextFormField(
                            maxLength: 2,
                            onSaved: (newValue) {
                              discont = int.parse(newValue!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidateDiscount() != true) {
                                return 'Invalid discount';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration.copyWith(
                              hintText: 'discount .. %',
                              labelText: 'discount',
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                        onSaved: (newValue) {
                          quantity = int.parse(newValue!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter quantity';
                          } else if (value.isValidateQuantity() != true) {
                            return 'Invalid quantity';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFormDecoration.copyWith(
                          hintText: 'Enter Quantity...',
                          labelText: 'Quantity',
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                        onSaved: (newValue) {
                          name = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        maxLength: 100,
                        decoration: textFormDecoration.copyWith(
                          hintText: 'Enter product name',
                          labelText: 'Name',
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                        onSaved: (newValue) {
                          description = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 5,
                        maxLength: 800,
                        decoration: textFormDecoration.copyWith(
                          hintText: 'Enter product description',
                          labelText: 'Description',
                        )),
                  ),
                ),
              ],
            ),
          ),
        )),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: imagesFileList!.isEmpty
                      ? () {
                          pickProductImages();
                        }
                      : () {
                          setState(() {
                            imagesFileList!.clear();
                          });
                        },
                  child: Icon(
                    imagesFileList!.isEmpty
                        ? Icons.photo_library
                        : Icons.delete_forever,
                    color: Colors.black,
                  )),
            ),
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: processing ? null : uploadProduct,
              child: processing
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
            ),
          ],
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

extension QuantityValidator on String {
  isValidateQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  isValidatePrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  isValidateDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
