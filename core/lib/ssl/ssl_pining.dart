// ignore: depend_on_referenced_packages
import 'package:http/io_client.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:core/ssl/share.dart';

class ApiIOClient extends IOClient {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return await Shared.initializeIOClient().then((value) => value.get(url));
  }
}