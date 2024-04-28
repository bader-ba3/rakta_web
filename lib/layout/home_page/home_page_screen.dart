import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rakta_web/controller/home_controller.dart';
import 'package:rakta_web/layout/home/home_screen.dart';
import 'package:rakta_web/layout/home_page/widget/app_bar.dart';

// Color backgroundColor = Color.fromRGBO(186, 227, 221, 1);
Color backgroundColor = Color(0xff00498f);
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double scroll = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(186, 227, 221, 1),
      backgroundColor: backgroundColor,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return ListView(
            controller: controller.scrollController,
            children: [
              Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            "assets/images/back.png",
                            width: MediaQuery.sizeOf(context).width / 1.5,
                          ),
                        ],
                      )),
                  Align(alignment: Alignment.center, child: HomeScreen()),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AppBarWidget(),
                  ),
                ],
              ),

              Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    SizedBox(
                      height: 700,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRect(
                            child: SizedBox(
                              height: 500,
                              width: MediaQuery.sizeOf(context).width,
                              child: Stack(
                                children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                                  child: Image.asset("assets/images/background.jpg",fit: BoxFit.fitWidth,  width: MediaQuery.sizeOf(context).width,),
                                ),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 0.0),
                                   child: SizedBox(
                                     height: 400,
                                     width: MediaQuery.sizeOf(context).width,
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                        child: Container(
                                          color: Colors.black.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                 ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(flex:5,child: Image.asset("assets/images/background_phone.png")),
                              Expanded(child: SizedBox()),
                              Expanded(flex:5,child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Download our App",style: TextStyle(color: Colors.orange,fontSize: 50,fontWeight: FontWeight.bold),),
                                  Text("Welcome to RAKTA - Your Ultimate Transportation Companion in Ras Al Khaimah!",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
                                  Text("Embark on a seamless journey across Ras Al Khaimah with our all-in-one transportation app. Whether you're commuting daily or exploring the city's sights, RAKTA has everything you need to make your travels smooth and hassle-free.",style: TextStyle(color: Colors.white,fontSize: 25),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/images/google_play.png",width: 250,fit: BoxFit.fill,),
                                      Image.asset("assets/images/app_store.png",width: 210,fit: BoxFit.fill,),
                                    ],
                                  )
                                ],
                              )),
                             SizedBox(width: 30,),
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 100,),
                    Container(
                        width: MediaQuery.sizeOf(context).width,
                          height:  MediaQuery.sizeOf(context).height/2,
                          decoration: BoxDecoration(  color: Color.fromRGBO(60, 65, 76, 1.0),image: DecorationImage(image: AssetImage("assets/images/footer.png"))),),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }


}
