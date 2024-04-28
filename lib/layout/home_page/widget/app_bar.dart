import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakta_web/controller/home_controller.dart';
import 'package:rakta_web/layout/home_page/home_page_screen.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
              gradient: LinearGradient(end: Alignment.bottomCenter, begin: Alignment.topCenter, colors: [
                backgroundColor.withOpacity(0.5),
                backgroundColor.withOpacity(0),
              ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                child: Image.asset(
                  "assets/images/logo-wide.png",
                  width: 300,
                ),
              ),
              appBarItem("Bus", () {
                controller.changeToBus();
              }),
              appBarItem("Taxi", () {
                controller.changeToTaxi();
              }),
              appBarItem("Application", () {
                controller.scrollController.animateTo(duration: Duration(milliseconds: 300),curve: Curves.linear,MediaQuery.sizeOf(context).height-150);
              }),
              appBarItem("About", () {
                controller.scrollController.animateTo(duration: Duration(milliseconds: 300),curve: Curves.linear,MediaQuery.sizeOf(context).height+200);
              }),
              SizedBox(),
              Container(
                width: 60,
                height:60,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/profile.png"),fit: BoxFit.fitWidth),color: Colors.grey.shade300,borderRadius: BorderRadius.circular(100),boxShadow: [BoxShadow(color: Colors.black45,offset: Offset(1, 1),blurRadius: 20)]),
              ),

              SizedBox(),
            ],
          ),
        );
      }
    );
  }
  appBarItem(String s, Null Function() param1) {
    return InkWell(
      onTap: param1,
      child: Text(
        s,
        style: TextStyle(fontSize: 22,color: Colors.white),
      ),
    );
  }
}
