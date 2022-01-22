import 'dart:convert';
import 'package:http/http.dart' as http;

import 'twiddar_base.dart';

class OauthToken {
  final String apiKey;
  final String apiSecret;

  String tokenType = "";
  String accessToken = "";
  bool _isSet = false;
  OauthToken(this.apiKey, this.apiSecret);

  void setfromJson(Map<String, dynamic> json) {
    this.tokenType = json['token_type'];
    this.accessToken = json['access_token'];
    this._isSet = true;
  }

  bool isSet() => this._isSet;
}
