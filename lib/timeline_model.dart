import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/service.dart';

class TimelineModel extends ChangeNotifier {
  final _list = <TweetModel>[];
  List<TweetModel> get list => _list;
  int get count => _list.length;

  void change(tweet) {
    _list.add(tweet);
    notifyListeners();
  }

  TimelineModel() {
    //init();
  }
  void init() {
    reflesh();
  }

  void reflesh() async {
    Future<List<TweetModel>> res = twitterService.getTweet();
    var ar = await res;
    _list.clear();
    ar.forEach((element) {
      change(element);
    });
  }
}
