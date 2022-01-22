import 'dart:convert';

import 'package:my_app/twiddar/twiddar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TweetModel {
  String image =
      'https://pics.prcm.jp/4f519f398831a/82957765/jpeg/82957765.jpeg';
  String name = "名ああ前表示する場所だよ";
  String account = "@account";
  String time = "1時間前";
  String text = "";
}

class TwitterService {
  final TwiddarV1 twiddarv1;
  TwitterService.twiddar(this.twiddarv1);
  TwitterService.appkey(apiKey, apiSecret)
      : this.twiddar(TwiddarV1(apiKey, apiSecret));
  TwitterService() : this.appkey('xxxxxxx', 'xxxxxxxxx');

  Future<List<TweetModel>> getTweet() async {
    var ar = <TweetModel>[];

    final queryParameters = {
      'count': ['50']
    };
    final TwiddarResponse res = await twiddarv1.timeline(queryParameters);

    //print("tweet body : ${jsonDecode(res.body)}");
    res.json.forEach((item) => {ar.add(makeTweet(item))});
    return ar;
  }

  TweetModel makeTweet(tw) {
    var tweet = new TweetModel();
    tweet.text = tw['text'];
    tweet.name = tw['user']["name"];

    //tweet.name = tw['user']['screen_name'];
    return tweet;
  }

  getAuthorizationURI() => twiddarv1.getAuthorizationURI();
  authorization(pin) async {
    final storage = new FlutterSecureStorage();
    final credential = await twiddarv1.authorization(pin);
    print("cred :$credential");

    await storage.write(key: "oauth_token", value: credential["oauth_token"]);
    await storage.write(
        key: "oauth_token_secret", value: credential["oauth_token_secret"]);
  }

  void setAccount(String oauthToken, String oauthTokenSecret) async {
    twiddarv1.accountCredentials(oauthToken, oauthTokenSecret);
    final storage = new FlutterSecureStorage();

    await storage.write(key: "oauth_token", value: oauthToken);
    await storage.write(key: "oauth_token_secret", value: oauthTokenSecret);
  }

  Future<Map<String, String>> getAuthorizationAccount() async {
    final storage = new FlutterSecureStorage();
    String? oauthToken = await storage.read(key: "oauth_token");
    String? oauthTokenSecret = await storage.read(key: "oauth_token_secret");
    if (oauthToken != null && oauthTokenSecret != null) {
      final result = {
        "oauth_token": oauthToken,
        "oauth_token_secret": oauthTokenSecret
      };
      return result;
    }
    return {};
  }
}

TwitterService twitterService = TwitterService();
