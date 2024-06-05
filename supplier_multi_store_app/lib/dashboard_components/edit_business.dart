import 'package:flutter/material.dart';
import 'package:supplier_multi_store_app/widgets/appbar_widgets.dart';

class EditBusiness extends StatelessWidget {
  const EditBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const AppbarTitle(title: 'Edit Business'),
    ));
  }
}
