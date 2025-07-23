import 'dart:convert';
import 'package:http/http.dart';


class APIs {
  static Future<String> getPublicIpAddress() async {
    try{
      final response = await get(Uri.parse('http://ip-api.com/json/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String ipAddress = data['query'];
        return ipAddress;
      } else {
        return '';
      }
    }catch(_){
      return '';
    }
  }
}

