import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:rakta_web/controller/home_controller.dart';

import '../../const/const.dart';
import '../../const/route.dart';
import '../../utils/hive.dart';
import '../../utils/utils.dart';
import '../choose_seat/choose_seat_screen.dart';

class TaxiBookingScreen extends StatefulWidget {
  final String from , to ,date;
  const TaxiBookingScreen({super.key,required this.from,required this.to,required this.date,});

  @override
  State<TaxiBookingScreen> createState() => _TaxiBookingScreenState();
}

class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
  String? from ,to,date;
  List countryList = ["Abu Dhabi", "Dubai", 'Sharjah', 'Ajman', "Umm Al Quwain", "Ras Al Khaimah" , "Fujairah"];
  List dayWeek = ["Monday", "Tuesday", 'Wednesday', 'Thursday', "Friday", "Saturday" , "Sunday"];
  int? showDetailsSelected;
  late DateTime dateTime ;
  String text = "";
  Set<Marker> marker={};
  Set<Polyline> polyline={};
  bool isFound = false;
  @override
  void initState() {
    HomeController homeController = Get.find<HomeController>();
    from = widget.from;
    to = widget.to;
    date = widget.date;
    dateTime = DateTime.parse(widget.date);
    text = "Searching for Taxi....";

    if(widget.date == DateTime.now().toString().split(" ")[0]){
      FirebaseFirestore.instance.collection("Orders").doc("0").set({
        "userName":HiveDataBase.getUserData().name,
        "userNumber":HiveDataBase.getUserData().mobile,
        // "fromLatLng":{"lat":homeViewModel.userPosition!.latitude,"lng":homeViewModel.userPosition!.longitude},
        "toLatLng": {"lat":homeController.toLatLng!.latitude,"lng":homeController.toLatLng!.longitude},
        "fromLatLng": {"lat":homeController.fromLatLng!.latitude,"lng":homeController.fromLatLng!.longitude},
        "fromAddress": from,
        "toAddress":to,
        "status":Const.tripStatusSearchDriver,
        "ploy":[],
      },SetOptions(merge: true));
      FirebaseFirestore.instance.collection("Orders").doc("0").snapshots().listen((event) {
        if(event.data()==null){
          Get.offAllNamed(Routes.home);
        }
        if(event.data()!['status'] != Const.tripStatusSearchDriver){
          text ="Taxi Founded \n Driver Will Rich you soon";
          isFound=true;
          setState(() {});
        }

      });
      // Future.delayed(Duration(seconds: 5)).then((value) {
      //   text ="Taxi Founded \n Driver Will Rich you soon";
      //   setState(() {});
      // });
    }else{
      text ="Trip is Schedule on "+widget.date;
    }

    Utils().getBytesFromAsset(path: 'images/location_icon.png', width: 50).then((value) {
      Marker newMarker = Marker(
        markerId: MarkerId("2"),
        icon: BitmapDescriptor.fromBytes(value),
        position: homeController.fromLatLng!,
      );
      marker.add(newMarker);
      setState(() {});
    });
    Utils().getBytesFromAsset(path: 'images/location_icon.png', width: 50).then((value) {
      Marker newMarker = Marker(
        markerId: MarkerId("1"),
        icon: BitmapDescriptor.fromBytes(value),
        position: homeController.toLatLng!,
      );
      marker.add(newMarker);
      setState(() {});
    });

    super.initState();

  }
  @override
  void dispose() {
    isFound=false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return Stack(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Container(
                  foregroundDecoration: BoxDecoration(color: Colors.black26),
                  child: AbsorbPointer(
                    absorbing: false,
                    child: GoogleMap(
                      markers: marker,
                      polylines: {
                        Polyline(
                            geodesic: true,
                            polylineId: PolylineId("polyline_id 00"),
                            color: Colors.black,
                            patterns: [PatternItem.dash(30), PatternItem.gap(10)],
                            points: MapsCurvedLines.getPointsOnCurve(   controller.fromLatLng!, controller.toLatLng!,),
                            width: 5,
                            // points: [
                            //   LatLng( 25.7351723,55.8894507),
                            //   LatLng( 25.7258256,55.7058549),
                            //   LatLng( 25.7013710,55.6169138),
                            //   LatLng( 25.6607415,55.5394203),
                            //   LatLng( 25.5978959,55.4670710),
                            //   LatLng( 25.5217660,55.4174741),
                            //   LatLng( 25.3500900,55.3813561),
                            // ],
                            consumeTapEvents: true,
                            onTap: () {
                            })
                      },
                      scrollGesturesEnabled: false,
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(target:controller.fromLatLng!,zoom: 16),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10,),
                  Center(
                    child: Hero(
                      tag: "bus-settings",
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 130,
                          width: MediaQuery.sizeOf(context).width / 1.3,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 10)]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "From",
                                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text(from??"Select from")),
                                        TextButton(onPressed: () async {
                                          String? selected ;
                                          String? _ =  await showDialog(context: context, builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: StatefulBuilder(
                                                builder: (context,setstate) {
                                                  return Container(
                                                    color: Colors.white,
                                                    height: MediaQuery.sizeOf(context).width/3.5,
                                                    width: MediaQuery.sizeOf(context).width/3.5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Pick Date of Your trip"),
                                                        SizedBox(height: 25,),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            itemCount: countryList.length,
                                                            itemBuilder: (context, index) {
                                                              return  InkWell(
                                                                  onTap: widget.to==countryList[index] ?null:(){
                                                                    selected = countryList[index];
                                                                    setstate(() {});
                                                                  },
                                                                  child: countryPicker(countryList[index],selected,setstate,widget.to));
                                                            },
                                                            // children: [
                                                            //   countryPicker("Sharja",selected,setstate),
                                                            //   countryPicker("Dubai",selected,setstate),
                                                            //   countryPicker("Rak",selected,setstate),
                                                            // ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25,),
                                                        Row(
                                                          children: [
                                                            Spacer(),
                                                            InkWell(
                                                                onTap: (){
                                                                  Get.back();
                                                                },
                                                                child: Text("Cancel",style: TextStyle(color: Colors.black,fontSize: 22),)),
                                                            SizedBox(width: 25,),
                                                            InkWell(
                                                              onTap: (){
                                                                if(selected!=null) {
                                                                  Get.back(result: (selected));
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: 100,
                                                                decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(15)),
                                                                child:   Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 22),)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                          ));
                                          if(_!=null){
                                            setState(() {
                                              from = _;
                                            });
                                          }
                                        }, child: Icon(Icons.ads_click,color: Colors.blue,)),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "To",
                                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text(to??"Select To")),
                                        TextButton(onPressed: () async {
                                          String? selected ;
                                          String? _ =  await showDialog(context: context, builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: StatefulBuilder(
                                                builder: (context,setstate) {
                                                  return Container(
                                                    color: Colors.white,
                                                    height: MediaQuery.sizeOf(context).width/3.5,
                                                    width: MediaQuery.sizeOf(context).width/3.5,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Pick Date of Your trip"),
                                                        SizedBox(height: 25,),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            itemCount: countryList.length,
                                                            itemBuilder: (context, index) {
                                                              return  InkWell(
                                                                  onTap: widget.from==countryList[index] ?null:(){
                                                                    selected = countryList[index];
                                                                    setstate(() {});
                                                                  },
                                                                  child: countryPicker(countryList[index],selected,setstate,widget.from));
                                                            },
                                                            // children: [
                                                            //   countryPicker("Sharja",selected,setstate),
                                                            //   countryPicker("Dubai",selected,setstate),
                                                            //   countryPicker("Rak",selected,setstate),
                                                            // ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25,),
                                                        Row(
                                                          children: [
                                                            Spacer(),
                                                            InkWell(
                                                                onTap: (){
                                                                  Get.back();
                                                                },
                                                                child: Text("Cancel",style: TextStyle(color: Colors.black,fontSize: 22),)),
                                                            SizedBox(width: 25,),
                                                            InkWell(
                                                              onTap: (){
                                                                if(selected!=null) {
                                                                  Get.back(result: (selected));
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: 100,
                                                                decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(15)),
                                                                child:   Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 22),)),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                          ));
                                          if(_!=null){
                                            setState(() {
                                              to = _;
                                            });
                                          }
                                        }, child: Icon(Icons.ads_click,color: Colors.blue,)),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Date",
                                      style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text(date??"Select Date")),
                                        TextButton(onPressed: () async {
                                          DateTime? selectedValue;
                                          DateTime? _ =  await showDialog(context: context, builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Container(
                                              color: Colors.white,
                                              height: 220,
                                              width: MediaQuery.sizeOf(context).width/2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text("Pick Date of Your trip"),
                                                  SizedBox(width: 25,),
                                                  SizedBox(
                                                    height: 100,
                                                    child: DatePicker(
                                                      DateTime.now(),
                                                      initialSelectedDate: DateTime.now(),
                                                      selectionColor: Colors.blue,
                                                      selectedTextColor: Colors.white,
                                                      onDateChange: (date) {
                                                        selectedValue = date;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 25,),
                                                  Row(
                                                    children: [
                                                      Spacer(),
                                                      InkWell(
                                                          onTap: (){
                                                            Get.back();
                                                          },
                                                          child: Text("Cancel",style: TextStyle(color: Colors.black,fontSize: 22),)),
                                                      SizedBox(width: 25,),
                                                      InkWell(
                                                        onTap: (){
                                                          Get.back(result: (selectedValue??DateTime.now()));
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(15)),
                                                          child:   Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 22),)),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                          if(_!=null){
                                            date = _.toString().split(" ")[0];
                                            setState(() {});
                                          }
                                        }, child: Icon(Icons.ads_click,color: Colors.blue,)),
                                      ],
                                    )
                                  ],
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Text(
                                //       "Quantity",
                                //       style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                //     ),
                                //     Container(
                                //       decoration: BoxDecoration(color: Colors.grey.shade100),
                                //       height: 50,
                                //       width: 150,
                                //       child: Row(
                                //         children: [
                                //           Expanded(
                                //             child: TextFormField(
                                //               controller: quantityController,
                                //               keyboardType: TextInputType.number,
                                //               inputFormatters: [
                                //                 FilteringTextInputFormatter.digitsOnly
                                //               ],
                                //               decoration: InputDecoration(border: InputBorder.none),
                                //
                                //             ),
                                //           ),
                                //           Column(
                                //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                                //             children: [
                                //               InkWell(
                                //                   onTap:(){
                                //                     quantityController.text=(int.parse(quantityController.text)+1).toString();
                                //                     setState(() {});
                                //                   },
                                //                   child: Icon(Icons.arrow_drop_up)),
                                //               InkWell(
                                //                   onTap:(){
                                //                     if(int.parse(quantityController.text)>1){
                                //                       quantityController.text=(int.parse(quantityController.text)-1).toString();
                                //                       setState(() {});
                                //                     }
                                //                   },
                                //                   child: Icon(Icons.arrow_drop_down)),
                                //             ],
                                //           )
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                Container(
                                  height: 75,
                                  width: 250,
                                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                    onTap: (){
                                     //TODO:   hello
                                    },
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Search",
                                              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                        child: Center(child: Text(text,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),))),
                  ),
                   Spacer(),
                  if(widget.date == DateTime.now().toString().split(" ")[0])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100)),
                        child:  isFound
                        ?Gif(image: AssetImage("assets/images/check.gif"),autostart: Autostart.once,width: 100,height: 100,)
                            :Gif(image: AssetImage("assets/images/checkLoading.gif"),autostart: Autostart.loop,width: 100,height: 100,)
                      ,)),


                  if(widget.date == DateTime.now().toString().split(" ")[0])
                  Spacer(),
                ],
              ),
            ],
          );
        }
      ),
    );
  }

  Widget countryPicker(text,selected,setstate,another){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
          width: MediaQuery.sizeOf(context).width/4,
          decoration: BoxDecoration(color: text == selected ?Colors.blue.withOpacity(0.5):Colors.transparent,borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(8.0),
          child: Text(text,style: TextStyle(color: text == another ?Colors.grey :text == selected ?Colors.white:Colors.black),)),
    );
  }

  Widget listItem(index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(15),boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 10)]),
            width: MediaQuery.sizeOf(context).width/1.5,
            height: showDetailsSelected==index?700:150,
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: 500,
                            height:150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("20:20",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    Text("-------------------"),
                                    Icon(Icons.timelapse,),
                                    Text("-------------------"),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    Text("20:20",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(from!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("Main Station",style: TextStyle(fontSize: 15,)),
                                      ],
                                    ),
                                    Text("2:05 H"),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(to!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("Alithad Station",style: TextStyle(fontSize: 15,)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                    SizedBox(width: 30,),
                    Container(height: 100,width: 2,color: Colors.grey.shade300,),
                    SizedBox(width: 30,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("1",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("Person",style: TextStyle(fontSize: 16),),
                        SizedBox(width: 10,),
                        Text("X",style: TextStyle(fontSize: 22),),
                        SizedBox(width: 10,),
                        Text("100",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("AED",style: TextStyle(fontSize: 16),),
                        SizedBox(width: 10,),
                        Text("=",style: TextStyle(fontSize: 22),),
                        SizedBox(width: 10,),
                        Text((1*100).toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("AED",style: TextStyle(fontSize: 16),),
                      ],
                    ),
                    SizedBox(width: 30,),
                    Container(height: 100,width: 2,color: Colors.grey.shade300,),
                    SizedBox(width: 30,),
                    SizedBox(
                      width: 300,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: (){
                                if(showDetailsSelected != index){
                                  showDetailsSelected = index;
                                }else{
                                  showDetailsSelected = null;
                                }

                                setState(() {});
                              },
                              child: Icon(showDetailsSelected==index?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,size: 50,)),
                          Spacer(),
                          Container(
                            height: 75,
                            width: 200,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              onTap: (){
                               Get.to(()=>ChooseSeatScreen(from:from!,to:to!,date:dateTime.toString().split(" ")[0]!));
                              },
                              child: Center(
                                  child:  Text(
                                    "Book",
                                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                if(showDetailsSelected==index)
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: 2,
                      width: MediaQuery.sizeOf(context).width/1.7,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width/1.6,
                      height: 500,
                      child: Row(
                        children: [
                          Expanded(
                          child: Container(
                            color: Colors.red,
                          ),
                          ),
                          Expanded(
                            child:  Row(
                              children: [
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    Expanded(child: Container(color: Colors.grey.shade300,width: 2,)),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(from!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Text("Alithad Station",style: TextStyle(fontSize: 15,)),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 355,),
                                                  Container(
                                                    height: 75,
                                                    width: 200,
                                                    decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.orange)),
                                                    child: Center(child: Text("Show on Map",style: TextStyle(color: Colors.orange,fontSize: 22),)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(to!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Text("Alithad Station",style: TextStyle(fontSize: 15,)),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 355,),
                                                  Container(
                                                    height: 75,
                                                    width: 200,
                                                    decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.orange)),
                                                    child: Center(child: Text("Show on Map",style: TextStyle(color: Colors.orange,fontSize: 22),)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    // SizedBox(height: 200,
                    // width: 200,
                    // child: StaticMap(
                    //   googleApiKey: "AIzaSyBrGI1H-6lZsYBY84AZrHjmdcUcYF_P63Y",
                    //   width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height,
                    //   scaleToDevicePixelRatio: true,
                    //   zoom: 14,
                    //   visible: const [
                    //     GeocodedLocation.address('Santa Monica Pier'),
                    //   ],
                    //   // styles: retroMapStyle,
                    //   paths: <Path>[
                    //     const Path(
                    //       color: Colors.blue,
                    //       points: [
                    //         // Can be both, addresses and coordinates.
                    //         GeocodedLocation.address('Santa Monica Pier'),
                    //         Location(34.011395, -118.494961),
                    //         Location(34.011921, -118.493360),
                    //         Location(34.012471, -118.491884),
                    //         Location(34.012710, -118.489420),
                    //         Location(34.014294, -118.486595),
                    //         Location(34.016630, -118.482920),
                    //         Location(34.018899, -118.480087),
                    //         Location(34.021314, -118.477136),
                    //         Location(34.022769, -118.474901),
                    //       ],
                    //     ),
                    //     Path.circle(
                    //       center: const Location(34.005641, -118.490229),
                    //       color: Colors.green.withOpacity(0.8),
                    //       fillColor: Colors.green.withOpacity(0.4),
                    //       encoded: true, // encode using encoded polyline algorithm
                    //       radius: 200, // meters
                    //     ),
                    //     const Path(
                    //       encoded: true,
                    //       points: [
                    //         Location(34.016839, -118.488240),
                    //         Location(34.019498, -118.491439),
                    //         Location(34.024106, -118.485734),
                    //         Location(34.021486, -118.482682),
                    //         Location(34.016839, -118.488240),
                    //       ],
                    //       fillColor: Colors.black45,
                    //       color: Colors.black,
                    //     )
                    //   ],
                    //   markers: const <Marker>[
                    //     Marker(
                    //       color: Colors.amber,
                    //       label: "X",
                    //       locations: [
                    //         GeocodedLocation.address("Santa Monica Pier"),
                    //         GeocodedLocation.latLng(34.012849, -118.501478),
                    //       ],
                    //     ),
                    //     Marker.custom(
                    //       anchor: MarkerAnchor.center,
                    //       icon: "https://goo.gl/1oTJ9Y",
                    //       locations: [
                    //         Location(34.012343, -118.482998),
                    //       ],
                    //     ),
                    //     Marker(
                    //       locations: [
                    //         Location(34.006618, -118.500901),
                    //       ],
                    //       color: Colors.cyan,
                    //       label: "W",
                    //     )
                    //   ],
                    // ),)

                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}
