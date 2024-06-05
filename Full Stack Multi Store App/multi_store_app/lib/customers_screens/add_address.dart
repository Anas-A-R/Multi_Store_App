import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/upload_product.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snack_bar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:uuid/uuid.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late String firstName;
  late String lastName;
  late String phoneNumber;
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';
  String countryValue = 'Choose Country';
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppbarTitle(title: 'Add Address'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          onSaved: (newValue) {
                            firstName = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter first name.';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'First Name',
                              hintText: 'Enter first name'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          onSaved: (newValue) {
                            lastName = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter last name.';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Last Name',
                              hintText: 'Enter last name'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          onSaved: (newValue) {
                            phoneNumber = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number.';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Phone Number',
                              hintText: 'Enter phone number'),
                        ),
                      ),
                    ),
                  ],
                ),
                SelectState(onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                }, onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                }, onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: YellowButton(
                      label: 'Add New Address',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (stateValue != 'Choose State' &&
                              cityValue != 'Choose City' &&
                              countryValue != 'Choose Country') {
                            _formKey.currentState!.save();
                            var addressId = const Uuid().v4();
                            await FirebaseFirestore.instance
                                .collection('customers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('address')
                                .doc(addressId)
                                .set({
                              'address_id': addressId,
                              'first_name': firstName,
                              'last_name': lastName,
                              'phone_number': phoneNumber,
                              'country': countryValue,
                              'state': stateValue,
                              'city': cityValue,
                              'default': true,
                            }).whenComplete(() => Navigator.pop(context));
                          } else {
                            MyMessageHandler.showSnackBar(_scaffoldMessengerKey,
                                'Please set your location');
                          }
                        } else {
                          MyMessageHandler.showSnackBar(
                              _scaffoldMessengerKey, 'Please fill all fields');
                        }
                      },
                      widthInPercent: 1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
