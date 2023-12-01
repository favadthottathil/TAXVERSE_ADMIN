import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> createPathForEcrypted(
  int count,
  String email,
) async {
  // Get this App Document Directory

  final appDirectory = await getApplicationDocumentsDirectory();

  final appDocDirFolder = Directory('${appDirectory.path}/Taxverse/$email/GstRegistration/GstApplication$count');

  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final appDocDirNewFolder = await appDocDirFolder.create(recursive: true);

    return appDocDirNewFolder.path;
  }
}

Future<File> createPathForDecrypted(List<int> decryptedBytes, String mail, int count, String fileName) async {
  File file;

  // Get the external storage directory
  final externalStorageDirectory = await getExternalStorageDirectory();

  // Create the 'Taxverse' folder if it doesn't exist
  final taxverseDirectory = await Directory('${externalStorageDirectory!.path}/GstDoc/$mail/gstDocument$count').create(recursive: true);

  // Create a new File object to represent the PDF file

  if (fileName.contains('PassportSizePhoto')) {
    const name = 'PassportSizePhoto.jpeg';
    file = File('${taxverseDirectory.path}/$name');
  } else {
    final name = '${fileName.replaceAll("'s", '').trim()}.pdf';
    file = File('${taxverseDirectory.path}/$name');
  }

  // Write the decrypted bytes to the File object
  await file.writeAsBytes(decryptedBytes);

  return file;
}
