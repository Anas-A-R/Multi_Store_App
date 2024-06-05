import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider extends ChangeNotifier {
  late Future<String> documentId;
  final Future<SharedPreferences> _perf = SharedPreferences.getInstance();
  static String _customerId = '';
  String get getData {
    return _customerId;
  }

  setCustomerId(User user) async {
    final SharedPreferences perf = await _perf;
    perf
        .setString('customerid', user.uid)
        .whenComplete(() => _customerId = user.uid);
    notifyListeners();
  }

  clearCustomerId() async {
    final SharedPreferences perf = await _perf;
    perf.setString('customerid', '').whenComplete(() => _customerId = '');
    notifyListeners();
  }

  Future<String> getDocumentId() async {
    return _perf.then((SharedPreferences sharedPreferences) =>
        sharedPreferences.getString('customerid') ?? '');
  }

  getDocId() async {
    await getDocumentId().then((value) => _customerId = value);
    notifyListeners();
  }
}
