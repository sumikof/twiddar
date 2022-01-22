import 'package:my_app/twiddar/twiddar.dart';

void main() async {
  final String apiKey = 'xxxxxxxx';
  final String apiSecret = 'xxxxxxxxxx';

  final String accountToken =
      "xxxxxx";
  final String accountSecret = "xxxxxxxx";

  TwiddarV1 t1 = TwiddarV1(apiKey, apiSecret);

  t1.accountCredentials(accountToken, accountSecret);

  final hoge = await t1.timeline({});
  print("v1 : ${hoge.json}");
  print("fin");
}
