// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<String> sendNotification(String title, String body) async {
//   String result = '';
//   print(
//       'calling send notification api__________________________________________________');
//   const String apiUrl =
//       'https://fcm.googleapis.com/v1/projects/multi-store-90b0d/messages:send'; // Correct endpoint
//   try {
//     String jsonData = json.encode({
//       "validate_only": "boolean",
//       "to": "/topics/anas",
//       "notification": {"body": body, "title": title}
//     });
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         "Access-Control_Allow_Origin": '*',
//         "Authorization":
//             "Bearer BKRMM3b5Q-JCWqsApoVU9ZAaUhaYikZH5FsqaGncThSBtbbh-eWNrV73sMtL40HHabpll9KU3_bm_lJ1Oof1Pe8"
//       },
//       body: jsonData,
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final decodedResponse = jsonDecode(response.body);
//       result = '$decodedResponse';
//     } else {
//       result =
//           'Failed to send notification. Status code : ${response.statusCode}  and ${response.body}';
//     }
//   } catch (e) {
//     result = 'Exception while sending notification: $e';
//   }
//   return result;
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendNotification(String title, String body) async {
  String result = '';
  print('Calling send notification API...');

  const String apiUrl =
      'https://fcm.googleapis.com/v1/projects/multi-store-90b0d/messages:send';

  try {
    String jsonData = json.encode({
      "validate_only": false,
      "message": {
        "topic": "anas",
        "notification": {"body": body, "title": title}
      }
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer AIzaSyBeJHxBxmqnkE2QsuayevI26c6BUAfbk0k"
      },
      body: jsonData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);
      result = '$decodedResponse';
    } else {
      result =
          'Failed to send notification. Status code: ${response.statusCode} and response is: ${response.body}';
    }
  } catch (e) {
    result = 'Exception while sending notification: $e';
  }
  return result;
}
