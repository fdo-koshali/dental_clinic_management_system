import 'dart:io';

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}