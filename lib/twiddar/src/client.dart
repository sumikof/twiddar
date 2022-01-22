import 'package:http/http.dart' as http;
import 'oauth.dart';
import 'twiddar_base.dart';
import 'twiddar_response.dart';

import 'dart:convert';

class TwiddarClientV2 extends TwiddarClient {
  final String API_VERSION = "/2";

  final OauthToken oauthtoken;
  TwiddarClientV2(String apiKey, String apiSecret)
      : oauthtoken = OauthToken(apiKey, apiSecret);

  Future<void> oauth(oauthUri) async {
    if (this.oauthtoken.isSet()) {
      return;
    }
    final base64encoded = base64.encode(latin1
        .encode('${this.oauthtoken.apiKey}:${this.oauthtoken.apiSecret}'));

    var url = Uri.parse(oauthUri);
    final response = await http.post(
      url,
      headers: {'Authorization': 'Basic $base64encoded'},
      body: {'grant_type': 'client_credentials'},
    );
    oauthtoken.setfromJson(jsonDecode(response.body));
  }

// Auth and Http Get
  @override
  Future<TwiddarResponse> twiddarApiGet(uri, queryParameters) async {
    await this.oauth('$TWITTER_URI/oauth2/token');

    final apiResponse = await http.get(
      this.makeuri(API_VERSION, uri, queryParameters),
      headers: {'Authorization': 'Bearer ${this.oauthtoken.accessToken}'},
    );
    return TwiddarResponse(apiResponse);
  }
}
