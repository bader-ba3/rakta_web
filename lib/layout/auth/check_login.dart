import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../const/route.dart';
import '../../utils/hive.dart';
import '../home_page/home_page_screen.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  // String  redirectLink = "https://ba3.co/rakta/check-login";
  String redirectLink = "http://localhost:54668/rakta";

  @override
  void initState() {
    print(Uri.base.queryParameters);
    print(Uri.base.queryParameters);
    print(Uri.base.queryParameters['code']);
    print("param "+Uri.base.queryParameters['code'].toString());
    if(Uri.base.queryParameters['code']!=null){
      getData(Uri.base.queryParameters['code']);
    }
    super.initState();
  }
String data ="";
  getData(code) async {
    print(redirectLink);
    print(redirectLink);
    if(code!=null) {
      http.post(Uri.parse("https://stg-id.uaepass.ae/idshub/token?grant_type=authorization_code&redirect_uri=${redirectLink}&code="+code!),headers: {
        "Authorization":"Basic c2FuZGJveF9zdGFnZTpzYW5kYm94X3N0YWdl",
        "Content-Type":"multipart/form-data",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods":"DELETE, POST, GET, OPTIONS",
        "Access-Control-Allow-Headers":"Content-Type, Authorization, X-Requested-With",
      }).then((value) {
        print(value.body);
        String access_token = json.decode( value.body)['access_token'];

        http.get(Uri.parse("https://stg-id.uaepass.ae/idshub/userinfo"),headers: {
          "Authorization":"Bearer "+access_token
        }).then((value) async {
          var name = json.decode(value.body)['firstnameEN']+" "+json.decode(value.body)['lastnameEN'];
          var gender = json.decode(value.body)['gender'];
          var mobile = json.decode(value.body)['mobile'];
          var email = json.decode(value.body)['email'];
          await HiveDataBase.setUserData((name: name,email: email,gender: gender,mobile: mobile));
          Get.offAll(()=>HomePageScreen());
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Check Your Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),),
          SizedBox(height: 20,),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
