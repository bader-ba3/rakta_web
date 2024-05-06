import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:html' show window;

class UAEPass extends StatefulWidget {
  const UAEPass({super.key});

  @override
  _UAEPassState createState() => _UAEPassState();
}

class _UAEPassState extends State<UAEPass> with SingleTickerProviderStateMixin {
String? data;
// String redirectLink = "http://localhost:58176/#/";
  String  redirectLink = "http://localhost:"+window.location.port+"/check-login";


  getData(code){
    if(code!=null) {
      http.post(Uri.parse("https://stg-id.uaepass.ae/idshub/token?grant_type=authorization_code&redirect_uri=${redirectLink}&code="+code!),headers: {
      "Authorization":"Basic c2FuZGJveF9zdGFnZTpzYW5kYm94X3N0YWdl",
      "Content-Type":"multipart/form-data"
    }).then((value) {
      print(value.body);
      String access_token = json.decode( value.body)['access_token'];

      http.get(Uri.parse("https://stg-id.uaepass.ae/idshub/userinfo"),headers: {
        "Authorization":"Bearer "+access_token
      }).then((value) {
        data = value.body.toString();
        setState(() {});
      });
    });
    }
  }




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("sigin using web"),
          InkWell(onTap: (){
            print(redirectLink);
            launchUrl(Uri.parse(
                "https://stg-id.uaepass.ae/idshub/authorize?redirect_uri=${redirectLink}&client_id=sandbox_stage&response_type=code&state=a&scope=urn:uae:digitalid:profile:general urn:uae:digitalid:profile:general:profileType urn:uae:digitalid:profile:general:unifiedId&acr_values=urn:safelayer:tws:policies:authentication:level:low"
            ), webOnlyWindowName:  '_self',
            );
          }, child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/UAEPASS.png"))
              ),
              child: SizedBox()),),

          ElevatedButton(onPressed: (){
            launchUrl(Uri.parse("https://stg-id.uaepass.ae/idshub/logout"));
          }, child: Text("logout")),
          if(data!=null)
            Text(data.toString())
        ],
      ),
    );
  }
}