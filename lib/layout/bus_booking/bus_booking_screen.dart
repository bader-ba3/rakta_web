import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:rakta_web/controller/home_controller.dart';
import 'package:rakta_web/layout/home_page/home_page_screen.dart';

import '../../utils/utils.dart';
import '../choose_seat/choose_seat_screen.dart';
import '../taxi_booking/taxi_booking_screen.dart';

class BusBookingScreen extends StatefulWidget {
  const BusBookingScreen({super.key});

  @override
  State<BusBookingScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  String? from ,to,date;
  List countryList = ["Abu Dhabi", "Dubai", 'Sharjah', 'Ajman', "Umm Al Quwain", "Ras Al Khaimah" , "Fujairah"];
  List dayWeek = ["Monday", "Tuesday", 'Wednesday', 'Thursday', "Friday", "Saturday" , "Sunday"];
  int? showDetailsSelected;
  late DateTime dateTime ;
  Set<Marker> marker={};
  @override
  void initState() {
    HomeController homeController = Get.find<HomeController>();
    from = homeController.from;
    to = homeController.to;
    date = homeController.date;
    dateTime = DateTime.parse(homeController.date!);
    super.initState();
    Utils().getBytesFromAsset(path: 'images/location_icon.png', width: 50).then((value) {
      Marker newMarker = Marker(
        markerId: MarkerId("1"),
        icon: BitmapDescriptor.fromBytes(value),
        position: LatLng( 25.7351723,55.8894507),
      );
      marker.add(newMarker);
    });

    Utils().getBytesFromAsset(path: 'images/location_icon.png', width: 50).then((value) {
      Marker newMarker = Marker(
        markerId: MarkerId("2"),
        icon: BitmapDescriptor.fromBytes(value),
        position: LatLng( 25.3500900,55.3813561),
      );
      marker.add(newMarker);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade100,),
      backgroundColor:  Colors.grey.shade100,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return ListView(
            children: [
              Center(
                child:  Hero(
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
                                        child: Text(controller.from??"Select from",maxLines: 2,)),
                                    TextButton(
                                        onPressed:() async {
                                          var _;
                                          if(controller.busPosition ==4){
                                            _ = await fromBusFun(controller.to);
                                          }else{
                                            _ = await fromTaxiFun("from");
                                          }
                                          if(_!=null){
                                            setState(() {
                                              controller.from=_;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.ads_click,color: Colors.blue,)),
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
                                        child: Text(controller.to??"Select To",maxLines: 2,)),
                                    TextButton(onPressed:
                                        () async {
                                      var _;
                                      if(controller.busPosition ==4){
                                        _ = await toBusFun();
                                      }else{
                                        _ = await fromTaxiFun("to");
                                      }
                                      if(_!=null){
                                        setState(() {
                                          controller.to=_;
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
                                        child: Text(controller.date??"Select Date")),
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
                                        controller.date = _.toString().split(" ")[0];
                                        controller.update();
                                        setState(() {});
                                      }
                                    }, child: Icon(Icons.ads_click,color: Colors.blue,)),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              height: 75,
                              width: 250,
                              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: (){
                                  if(controller.from!=null&&controller.to!=null&&controller.date!=null){
                                    if(controller.busPosition ==2){
                                      Get.to(BusBookingScreen());
                                    }else{
                                      Get.to(TaxiBookingScreen(from:controller.from!,to:controller.to!,date:controller.date!));
                                    }
                                  }
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
              SizedBox(height: 50,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          dateTime =  dateTime.subtract(Duration(days: 1));
                          setState(() {});
                        },
                        child: Icon(Icons.arrow_back_ios_sharp)),
                    SizedBox(
                        width: 300,
                        child: Text(dayWeek[dateTime.weekday-1]+" "+dateTime.toString().split(" ")[0],style: TextStyle(fontSize: 23),)),
                    InkWell(
                        onTap:(){
                          dateTime= dateTime.add(Duration(days: 1));
                          setState(() {});
                        },
                        child: Icon(Icons.arrow_forward_ios_sharp)),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => listItem(index),)
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
                                    Text((index+1).toString()+":00",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    Text("-------------------"),
                                    Icon(Icons.timelapse,),
                                    Text("-------------------"),
                                    Icon(Icons.circle_outlined,color: Colors.red,),
                                    Text((index+2).toString()+":30",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
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
                           child: GoogleMap(
                             initialCameraPosition: CameraPosition(target: LatLng(25.524841,55.719851),zoom: 10),
                            markers: marker,
                             scrollGesturesEnabled: false,
                             compassEnabled: false,
                             zoomControlsEnabled: false,
                             zoomGesturesEnabled: false,
                             mapToolbarEnabled: false,
                             polylines: {
                               Polyline(
                                  geodesic: true,
                                   polylineId: PolylineId("polyline_id 00"),
                                   color: Colors.black,
                                   patterns: [PatternItem.dash(30), PatternItem.gap(10)],
                                   points: MapsCurvedLines.getPointsOnCurve(   LatLng( 25.7351723,55.8894507),  LatLng( 25.3500900,55.3813561),),
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
                           ),
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
                                            Text("Bus Station",style: TextStyle(fontSize: 15,)),
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
                                            Text("Bus Station",style: TextStyle(fontSize: 15,)),
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
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
  Future<String?> fromBusFun(to) async {
    String? selected;
    String? _ = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: StatefulBuilder(builder: (context, setstate) {
            return Container(
              color: Colors.white,
              height: MediaQuery.sizeOf(context).width / 3.5,
              width: MediaQuery.sizeOf(context).width / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pick Date of Your trip"),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: countryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: to == countryList[index]
                                ? null
                                : () {
                              selected = countryList[index];
                              setstate(() {});
                            },
                            child: countryPicker(countryList[index], selected, setstate, to));
                      },
                      // children: [
                      //   countryPicker("Sharja",selected,setstate),
                      //   countryPicker("Dubai",selected,setstate),
                      //   countryPicker("Rak",selected,setstate),
                      // ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          )),
                      SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (selected != null) {
                            Get.back(result: (selected));
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ));

    return _;
  }

  Future<String?> fromTaxiFun(ref) async {
    TextEditingController textController = TextEditingController();
    String? address = await showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<HomeController>(builder: (controller) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            title: StatefulBuilder(builder: (context, setstate) {
              return Container(
                color: Colors.white,
                width: MediaQuery.sizeOf(context).width / 3 + 100,
                height: MediaQuery.sizeOf(context).width / 3 + 100,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                          height: 50,
                          child: TypeAheadField<String>(
                            hideOnEmpty: true,
                            suggestionsCallback: (search) => controller.getPlace(search),
                            builder: (context, controller, focusNode) {
                              return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'City',
                                  ));
                            },
                            itemBuilder: (context, city) {
                              return ListTile(
                                title: Text(city),
                                subtitle: Text(city),
                              );
                            },
                            onSelected: (name) {
                              Get.back(result: name);
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GoogleMap(
                            markers: controller.markers,
                            myLocationButtonEnabled: false,
                            compassEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            onMapCreated: (_controller) async {
                              controller.controller = Completer();
                              controller.controller.complete(_controller);
                              controller.animateCamera(
                                LatLng(25.770223, 55.930957),
                              );
                              Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                              controller.userPosition = LatLng(position.latitude, position.longitude);
                              controller.animateCamera(LatLng(position.latitude, position.longitude));
                              controller.setMarker(LatLng(position.latitude, position.longitude), "location_arrow_icon", "location_arrow_icon", "0", size: 30);
                            },
                            onTap: (argument) async {
                              controller.setMarker(argument, "location_pin", "marker", "0", size: 30);
                              await controller.getLocationName(argument);
                              if (controller.places.places!.isEmpty) {
                                controller.markers.removeWhere((element) => element.position == argument);
                              } else {
                                textController.text = controller.places.places!.first.displayName!.text!;
                              }
                              setstate(() {});
                            },
                            onLongPress: (argument) async {
                              controller.setMarker(argument, "location_pin", "marker", "0", size: 30);
                              await controller.getLocationName(argument);
                              if (controller.places.places!.isEmpty) {
                                controller.markers.removeWhere((element) => element.position == argument);
                              } else {
                                textController.text = controller.places.places!.first.displayName!.text!;
                              }
                              setstate(() {});
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(25.770223, 55.930957),
                              zoom: 17,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: controller.userPosition != null
                              ? () {
                            Get.back(result: "My Location");
                          }
                              : null,
                          child: Container(
                            height: 50,
                            width: 220,
                            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                                  "Select Your Location",
                                  style: TextStyle(color: Colors.white, fontSize: 22),
                                )),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black, fontSize: 22),
                            )),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: (controller.places.places?.isNotEmpty ?? false)
                              ? () {
                            Get.back(result: (controller.places.places!.first.displayName!.text));
                          }
                              : null,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white, fontSize: 22),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
      },
    );
    // if(address!=null){
    //   setState(() {
    //     if(ref == "to"){
    //       to = address;
    //     }else{
    //       from = address;
    //     }
    //
    //   });
    // }
    return address;
  }

  Future<String?> toBusFun() async {
    String? selected;
    String? _ = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: GetBuilder<HomeController>(builder: (controller) {
            return StatefulBuilder(builder: (context, setstate) {
              return Container(
                color: Colors.white,
                height: MediaQuery.sizeOf(context).width / 3.5,
                width: MediaQuery.sizeOf(context).width / 3.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pick Date of Your trip"),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: controller.from == countryList[index]
                                  ? null
                                  : () {
                                selected = countryList[index];
                                setstate(() {});
                              },
                              child: countryPicker(countryList[index], selected, setstate, controller.from));
                        },
                        // children: [
                        //   countryPicker("Sharja",selected,setstate),
                        //   countryPicker("Dubai",selected,setstate),
                        //   countryPicker("Rak",selected,setstate),
                        // ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black, fontSize: 22),
                            )),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () {
                            if (selected != null) {
                              Get.back(result: (selected));
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white, fontSize: 22),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
          }),
        ));
    if (_ != null) {
      // setState(() {
      //   to = _;
      // });
    }
    return _;
  }
}
