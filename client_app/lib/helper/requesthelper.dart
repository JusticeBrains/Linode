import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    var newUrl = Uri.parse(url);
    http.Response response = await http.get(newUrl);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
