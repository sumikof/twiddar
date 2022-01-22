import 'package:http/http.dart' as http;
import 'dart:convert';

class TwiddarResponse {
  final http.Response _response;
  final _json_data;
  TwiddarResponse(http.Response res)
      : _response = res,
        _json_data = jsonDecode(res.body);

  get json => _json_data;
  get status => _response.statusCode;
  get body => _response.body;

  operator [](String key) {
    return this.json[key];
  }
}
