import 'package:my_app/twiddar/twiddar.dart';

void main() async {
  final String apiKey = 'xxxxxxx';
  final String apiSecret = 'xxxxxxxx';

  Twiddar twider = Twiddar(apiKey, apiSecret);

  final queryParameters = {
    'expansions': ['pinned_tweet_id'],
    'user.fields': [
      'name',
      'created_at',
      'description',
    ],
  };

  final TwiddarResponse userinfo = await twider.users.userLookup
      .retrieveSingleUserWithUsername("sumikof", queryParameters);

  print("userinfo: ${userinfo.json}");
  final TwiddarResponse followings = await twider.users.follows
      .lookupFollowingOfAUserBID(userinfo["data"]["id"], {});
  print("status : ${followings.status}");
  print("body ${followings.body}");
  print("follow: ${followings['data']}");

  final timelineParameters = {
    'expansions': [
      'author_id',
    ],
    'user.fields': [
      'name',
      'created_at',
      'description',
    ],
    'tweet.fields': [
      'created_at',
    ]
  };
  final TwiddarResponse timline = await twider.tweets.timelines
      .userMentionTImelineWithId(userinfo["id"], timelineParameters);
  print("mention :${timline.json}");
}
