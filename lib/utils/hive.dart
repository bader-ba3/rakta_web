import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  static late Box<String> accountBox;
  static Future<void> init() async {
    await Hive.initFlutter();
    accountBox=await Hive.openBox<String>("Account");
  }
  static ({String name,String gender,String email,String mobile}) getUserData(){
     String mobile = accountBox.get("mobile").toString();
     String name = accountBox.get("name").toString();
     String gender =accountBox.get("gender").toString();
     String email =accountBox.get("email").toString();
     return (name: name,gender: gender,email: email,mobile:mobile);
  }

  static  setUserData(({String name,String gender,String email,String mobile}) data)async{
    await accountBox.put("mobile",data.mobile);
    await accountBox.put("name",data.name);
    await accountBox.put("gender",data.gender);
    await accountBox.put("email",data.email);
     return true;
  }

  static  deleteUserData(){
    accountBox.delete("mobile");
    accountBox.delete("name");
    accountBox.delete("gender");
    accountBox.delete("email");
  }


}