import 'twiddar_base.dart';
import 'twiddar_response.dart';

class Tweets {
  final Lookup lookup;
  final Timelines timelines;
  final Search search;
  final Counts counts;
  final Retweets retweets;
  Tweets(TwiddarClient client)
      : lookup = Lookup(client),
        timelines = Timelines(client),
        search = Search(client),
        counts = Counts(client),
        retweets = Retweets(client);
}

class Lookup extends TwiddarServiceBase {
  Lookup(TwiddarClient client) : super(client);

  Future<TwiddarResponse> retrieveMultipleTweetsWithIds(
          queryParameters) async =>
      this.client.twiddarApiGet('/tweets/', queryParameters);

  Future<TwiddarResponse> retrieveSingleTweetWithID(
          id, queryParameters) async =>
      this.client.twiddarApiGet('/tweets/$id', queryParameters);
}

class Timelines extends TwiddarServiceBase {
  Timelines(TwiddarClient client) : super(client);

  Future<TwiddarResponse> userTweetTimelineWithId(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/tweets', queryParameters);

  Future<TwiddarResponse> userMentionTImelineWithId(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/mentions', queryParameters);

  Future<TwiddarResponse> userTweetTimelineWithUsername(
          username, queryParameters) async =>
      this.client.twiddarApiGet(
          '/users/by/username/$username/tweets', queryParameters);

  Future<TwiddarResponse> userMentionTImelineWithUsername(
          username, queryParameters) async =>
      this.client.twiddarApiGet(
          '/users/by/username/$username/mentions', queryParameters);
}

class Search extends TwiddarServiceBase {
  Search(TwiddarClient client) : super(client);

  Future<TwiddarResponse> recentSearch(queryParameters) async =>
      this.client.twiddarApiGet('/tweets/search/recent', queryParameters);

  Future<TwiddarResponse> fullArchiveSearch(queryParameters) async =>
      this.client.twiddarApiGet('/tweets/search/all', queryParameters);
}

class Counts extends TwiddarServiceBase {
  Counts(TwiddarClient client) : super(client);
  Future<TwiddarResponse> recentTweetCounts(queryParameters) async =>
      this.client.twiddarApiGet('/tweets/counts/recent', queryParameters);

  Future<TwiddarResponse> fullArchiveTweetCounts(queryParameters) async =>
      this.client.twiddarApiGet('/tweets/counts/all', queryParameters);
}

class Retweets extends TwiddarServiceBase {
  Retweets(TwiddarClient client) : super(client);

  Future<TwiddarResponse> retweetsLookup(userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/retweeted_by', queryParameters);
}
