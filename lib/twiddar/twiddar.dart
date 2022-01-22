// ignore: import_of_legacy_library_into_null_safe
import 'src/client.dart';
import 'src/tweets.dart';
import 'src/twiddar_base.dart';
import 'src/v1/twiddar_client_v1.dart';
import 'src/twiddar_response.dart';
import 'src/users.dart';

export 'src/twiddar_base.dart';
export 'src/twiddar_response.dart';

//
//
//
class Twiddar {
  //
  final Tweets tweets;
  //
  final Users users;

  /*
   * 
   * 
   */
  Twiddar.client(TwiddarClient client)
      : tweets = Tweets(client),
        users = Users(client);
  /*
   * 
   * 
   */
  Twiddar(apiKey, apiSecret) : this.client(TwiddarClientV2(apiKey, apiSecret));
}

class TwiddarV1 {
  final TwiddarClientV1 client;
  TwiddarV1.client(this.client);

  TwiddarV1(apiKey, apiSecret)
      : this.client(TwiddarClientV1(apiKey, apiSecret));

  Future<TwiddarResponse> timeline(queryParameters) async {
    return await client.twiddarApiGet(
        '/statuses/home_timeline.json', queryParameters);
  }

  void accountCredentials(token, tokenSecret) =>
      client.accountCredentials(token, tokenSecret);

  Future<String> getAuthorizationURI() async => client.getAuthorizationURI();

  Future<Map<String, dynamic>> authorization(verifier) async =>
      client.authorization(verifier);
}
