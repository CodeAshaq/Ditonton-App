// import 'dart:io';
// import 'package:flutter/services.dart';
// // ignore: depend_on_referenced_packages
// import 'package:http/io_client.dart';

// class Shared {
//   static Future<IOClient> initializeIOClient() async {
//     final ByteData sslCert =
//         await rootBundle.load('certificates/certificate.cer');
//     SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
//     securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
//     HttpClient httpClient = HttpClient(context: securityContext);
//     httpClient.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => false;
//     return IOClient(httpClient);
//   }
// }
