// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: use_build_context_synchronously

import 'dart:core';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyAppNew extends StatefulWidget {
  const MyAppNew({super.key});
  @override
  MyAppNewState createState() => MyAppNewState();
}

class MyAppNewState extends State<MyAppNew> {
  List fruit = [];

  @override
  Widget build(BuildContext context) {
    final localhostMapped =
        kIsWeb || !Platform.isAndroid ? 'localhost' : '10.0.2.2';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Functions Example'),
        ),
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: fruit.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${fruit[index]}'),
              );
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () async {
                    // See .github/workflows/scripts/functions/src/index.ts for the example function we
                    // are using for this example
                    HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallable(
                      'listFruit',
                      options: HttpsCallableOptions(
                        timeout: const Duration(seconds: 5),
                      ),
                    );

                    await callingFunction(callable, context);
                  },
                  label: const Text('Call Function'),
                  icon: const Icon(Icons.cloud),
                  backgroundColor: Colors.deepOrange,
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () async {
                    // See .github/workflows/scripts/functions/src/index.ts for the example function we
                    // are using for this example
                    HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallableFromUrl(
                      'http://$localhostMapped:5001/flutterfire-e2e-tests/us-central1/listfruits2ndgen',
                      options: HttpsCallableOptions(
                        timeout: const Duration(seconds: 5),
                      ),
                    );

                    await callingFunction(callable, context);
                  },
                  label: const Text('Call 2nd Gen Function'),
                  icon: const Icon(Icons.cloud),
                  backgroundColor: Colors.deepOrange,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> callingFunction(
    HttpsCallable callable,
    BuildContext context,
  ) async {
    try {
      final result = await callable();
      setState(() {
        fruit.clear();
        result.data.forEach((f) {
          fruit.add(f);
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR: ${e.toString()}'),
        ),
      );
    }
  }
}
