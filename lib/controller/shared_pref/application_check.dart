import 'package:shared_preferences/shared_preferences.dart';

class ApplicatinCheckShardpref {
  isCheckInformation(bool value,String email, int count) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    await sharedPreference.setBool('$email${count}isCheckInformation', value);
  }

  Future<bool?> getIsCheckInformation(String email, int count) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return  sharedPreferences.getBool('$email${count}isCheckInformation');
  }

   isCheckDocuments(bool value,String email, int count) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    await sharedPreference.setBool('$email${count}isCheckDocuments', value);
  }

 Future<bool?> getisCheckDocuments(String email, int count) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return  sharedPreferences.getBool('$email${count}isCheckDocuments');
  }

   isFinalCheck(bool value,String email, int count) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    await sharedPreference.setBool('$email${count}isFinalCheck', value);
  }

 Future<bool?> getIsFinalCheck(String email, int count) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return  sharedPreferences.getBool('$email${count}isFinalCheck');
  }
}
