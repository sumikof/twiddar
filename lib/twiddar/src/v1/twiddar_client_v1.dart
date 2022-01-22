import 'package:my_app/twiddar/twiddar.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class TwiddarCredentials {
  oauth1.Credentials cred;
  TwiddarCredentials() : cred = oauth1.Credentials("", "");
}

class TwiddarClientV1 extends TwiddarClient {
  final String API_VERSION = "/1.1";
  final clientCredentials;
  final platform = oauth1.Platform(
    'https://api.twitter.com/oauth/request_token',
    'https://api.twitter.com/oauth/authorize',
    'https://api.twitter.com/oauth/access_token',
    oauth1.SignatureMethods.hmacSha1,
  );
  late final auth = oauth1.Authorization(clientCredentials, platform);
  oauth1.Credentials? tokenCredentials;
  oauth1.Credentials? _accountCredentials;
  oauth1.Client? oauthClient;

  TwiddarClientV1(String apiKey, String apiSecret)
      : clientCredentials = oauth1.ClientCredentials(
          apiKey,
          apiSecret,
        );

  Future<String> getAuthorizationURI() async {
    // CallbackURLを"oob"とすることでPINでの認証とできる
    var response = await auth.requestTemporaryCredentials('oob');
    tokenCredentials = response.credentials;
    return auth.getResourceOwnerAuthorizationURI(tokenCredentials!.token);
  }

  void accountCredentials(token, tokenSecret) =>
      this._accountCredentials = oauth1.Credentials(token, tokenSecret);

  Future<Map<String, dynamic>> authorization(verifier) async {
    if (tokenCredentials == null) {
      throw NullThrownError();
    }
    if (_accountCredentials == null) {
      final res = await auth.requestTokenCredentials(
        tokenCredentials!,
        verifier,
      );
      print('Access Token: ${res.credentials.token}');
      print('Access Token Secret: ${res.credentials.tokenSecret}');

      _accountCredentials = res.credentials;
    }
    return _accountCredentials!.toJSON();
    // 取得した Access Token を使ってAPIにリクエストできる
  }

  oauth1.Client httpClient() {
    if (oauthClient == null) {
      this.oauthClient = oauth1.Client(
        platform.signatureMethod,
        clientCredentials,
        _accountCredentials!,
      );
    }
    return this.oauthClient!;
  }

  @override
  Future<TwiddarResponse> twiddarApiGet(uri, queryParameters) async {
    final apiResponse = await this.httpClient().get(
          this.makeuri(API_VERSION, uri, queryParameters),
        );
    return TwiddarResponse(apiResponse);
  }
}
