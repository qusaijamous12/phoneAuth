import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper{
  static SharedPreferences ?sharedPreferences;

  static init()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }




  static Future<bool> SaveData({
    required String key,
    required dynamic value
  })async{
    if(value is int){
      return await sharedPreferences!.setInt(key, value);
    }
    if(value is double){
      return await sharedPreferences!.setDouble(key, value);
    }
    if(value is String){
      return await sharedPreferences!.setString(key, value);
    }
    return await sharedPreferences!.setBool(key, value);



  }

  static dynamic getData({
    required String key
  }
      ){
    return sharedPreferences!.get(key);
  }
  static Future<bool> RemoveData({
    required String key
  })async{
    return await sharedPreferences!.remove(key);
  }


}