import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'constants.dart';
import 'package:riafy/services/feeds.dart';

class Services {



  static Future<String> getblogs() async {

    String url = Constants.FEED_URL;
    Response response = await http.get(Uri.parse(url));

    return response.body;
  }


}
