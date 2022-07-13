// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'dart:io';

class ApiIOClient extends IOClient {
  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificate.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);

    return ioClient.get(url);
  }
}
