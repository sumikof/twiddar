import 'twiddar_response.dart';

/*
 *
 *
 */
class TwiddarServiceBase {
  final TwiddarClient client;
  TwiddarServiceBase(this.client);
}

final String TWITTER_URI = "https://api.twitter.com";

abstract class TwiddarClient {
  Future<TwiddarResponse> twiddarApiGet(uri, queryParameters);

/*
 * Map<String, List<String>> queryParameters
 */
  String makeparam(queryParameters) {
    if (queryParameters.length == 0) {
      return "";
    }
    // join request queryParameters
    return queryParameters.entries.map((paramEntry) {
      final value = paramEntry.value.join(',');
      return '${paramEntry.key}=$value';
    }).reduce((param1, param2) {
      return '${param1}&${param2}';
    });
  }

  Uri makeuri(api_version, uri, queryParameters) => Uri.parse(
      TWITTER_URI + api_version + uri + "?" + makeparam(queryParameters));
}
