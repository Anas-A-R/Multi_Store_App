// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplier_multi_store_app/utilities/categ_list.dart';
import 'package:supplier_multi_store_app/widgets/snack_bar.dart';
import 'package:supplier_multi_store_app/widgets/yellow_button.dart';
import 'package:path/path.dart' as path;

class EditProductScreen extends StatefulWidget {
  final dynamic items;
  const EditProductScreen({super.key, required this.items});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  List<dynamic> imageUrlList = [];
  List<XFile>? imagesFileList = [];

  dynamic _pickedImageError;
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['product_images'];
    return ListView.builder(
      itemCount: itemImages.length,
      itemBuilder: (context, index) {
        return Image.network(itemImages[index].toString());
      },
    );
  }

  Widget previewImages() {
    return ListView.builder(
      itemCount: imagesFileList!.length,
      itemBuilder: (context, index) {
        return Image.file(File(imagesFileList![index].path));
      },
    );
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        if (mainCategoryValue != 'select category' &&
            subCategoryValue != 'sub category') {
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
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldMessengerKey, 'Please select categories first');
        }
      } else {
        imageUrlList = widget.items['product_images'];
      }
    } else {
      MyMessageHandler.showSnackBar(
          _scaffoldMessengerKey, 'Please fill all fields');
    }
  }

  editProductData() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.items['product_id']);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'product_name': name,
        'product_description': description,
        'product_price': price,
        'product_instoke': quantity,
        'product_mainCategory': mainCategoryValue,
        'product_subCategory': subCategoryValue,
        'product_images': imageUrlList,
        'product_discount': discont,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    await uploadImages().whenComplete(() => editProductData());
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
                  Column(
                    children: [
                      Row(
                        children: [
                          //images container
                          Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: Colors.blueGrey.shade100,
                              child: previewCurrentImages()),
                          //categories
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //main category
                                Column(
                                  children: [
                                    const Text('Main category',
                                        style: TextStyle(color: Colors.red)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 25,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                          widget.items['product_mainCategory']),
                                    )
                                  ],
                                ),
                                //sub category
                                Column(
                                  children: [
                                    const Text('Subcategory',
                                        style: TextStyle(color: Colors.red)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 25,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                          widget.items['product_subCategory']),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpandablePanel(
                        theme: const ExpandableThemeData(hasIcon: false),
                        header: Container(
                          margin: const EdgeInsets.all(20),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            'Change images and categories',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        collapsed: const SizedBox(),
                        expanded: changeImages(),
                      )
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
                              initialValue: widget.items['product_price']
                                  .toStringAsFixed(2),
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                              initialValue:
                                  widget.items['product_discount'].toString(),
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                          initialValue:
                              widget.items['product_instoke'].toString(),
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
                          initialValue: widget.items['product_name'].toString(),
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
                          initialValue:
                              widget.items['product_description'].toString(),
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
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          )),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                              saveChanges();
                            },
                            widthInPercent: 0.5)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                YellowButton(
                    color: Colors.pink.shade400,
                    titleColor: Colors.white,
                    label: 'Delete',
                    onPressed: () {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('products')
                          .doc(widget.items['product_id']);
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        transaction.delete(documentReference);
                      }).whenComplete(() => Navigator.pop(context));
                    },
                    widthInPercent: 0.85)
              ],
            ),
          )),
    );
  }

  Widget changeImages() {
    return Column(
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
                        items: maincateg.map<DropdownMenuItem<String>>((value) {
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
                        items:
                            subCategList.map<DropdownMenuItem<String>>((value) {
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
        Padding(
          padding: const EdgeInsets.all(20),
          child: imagesFileList!.isNotEmpty
              ? YellowButton(
                  label: "Reset Images",
                  onPressed: () {
                    setState(() {
                      imagesFileList!.clear();
                    });
                  },
                  widthInPercent: 0.5)
              : YellowButton(
                  label: "Change Images",
                  onPressed: () {
                    pickProductImages();
                  },
                  widthInPercent: 0.5),
        )
      ],
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
