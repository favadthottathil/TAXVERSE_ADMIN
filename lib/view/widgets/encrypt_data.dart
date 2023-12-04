import 'package:encrypt/encrypt.dart' as encrypt;



class EncryptData {

  encrypt.Key generateKey() {

    final key = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef');
    return key;
  }

  encryptedData(String data, encrypt.Key key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

     final staticIV = encrypt. IV.fromUtf8('taxverse');

    final encrypted = encrypter.encrypt(data,iv: staticIV);

    return encrypted.base64;
  }
}
