import 'dart:async';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakta_web/controller/home_controller.dart';
import 'package:rakta_web/layout/bus_booking/bus_booking_screen.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/hive.dart';
import '../taxi_booking/taxi_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List countryList = ["Abu Dhabi", "Dubai", 'Sharjah', 'Ajman', "Umm Al Quwain", "Ras Al Khaimah", "Fujairah"];
  late Position position;
  double? initX;
  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) => position = value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: GetBuilder<HomeController>(builder: (controller) {
        return Column(
          children: [
            Spacer(
              flex: 4,
            ),
            Text(
              "Book Your " + (controller.busPosition == 4 ? "Bus" : "Taxi") + " Now!",
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
            Spacer(
              flex: 1,
            ),
            Center(
                child: SizedBox(
              height: 340,
              width: MediaQuery.sizeOf(context).width,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    width: MediaQuery.sizeOf(context).width / 4,
                    top: MediaQuery.sizeOf(context).width / 12,
                    // right: MediaQuery.sizeOf(context).width/4,
                    right: MediaQuery.sizeOf(context).width / controller.carPosition,
                    duration: Duration(milliseconds: 300),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      overlayColor: MaterialStatePropertyAll(Colors.transparent),
                      onTap: () {
                        controller.changeToTaxi();
                      },
                      child: Image.asset(
                        "assets/images/taxi.png",
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.sizeOf(context).width / 2,
                    // right: MediaQuery.sizeOf(context).width/4,
                    left: MediaQuery.sizeOf(context).width / controller.busPosition,
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
                        onTap: () {
                          controller.changeToBus();
                        },
                        child: Image.asset(
                          "assets/images/bus.png",
                          fit: BoxFit.cover,
                        )),
                  ),
                  GestureDetector(
                    onHorizontalDragStart: (details) {
                      initX = details.globalPosition.dx;
                    },
                    onHorizontalDragUpdate: (details) {
                      // print(details.globalPosition.dx);
                      // initX ??= details.globalPosition.dx;
                      // print("a "+ initX.toString() + "   "+(initX!-500).toString() +"   "+(initX!+500).toString() );
                      // if(initX!=null &&initX! > details.globalPosition.dx!-1000){
                      //   // print("left");
                      //   if(controller.busPosition == 1.1){
                      //     // print("chang bus");
                      //     controller.changeToBus();
                      //   }
                      // }
                      // if(initX!=null &&initX! < details.globalPosition.dx!+1000){
                      //   // print("right from "+ initX.toString() + "to "+details.globalPosition.dx.toString());
                      //   if(controller.carPosition == 1.1){
                      //     // print("chang taxi");
                      //     controller.changeToTaxi();
                      //   }
                      // }
                      if (initX != null) {
                        final currentPosition = details.globalPosition;
                        if (currentPosition.dx - initX! > 20) {
                          if(controller.carPosition == 1.1){
                            controller.changeToTaxi();
                          }
                          initX = null;
                        } else if (currentPosition.dx - initX! < -20) {
                          if(controller.busPosition == 1.1){
                            controller.changeToBus();
                          }
                          initX = null;
                        }
                      }
                    },
                    onHorizontalDragCancel: (){
                      // initX=null;
                    },   onHorizontalDragEnd: (details){
                    initX=null;
                  },
                    child: Container(
                      color: Colors.red.withOpacity(0.0),
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            )),
            Hero(
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
                              "From ",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      controller.from ?? "Select from",
                                      maxLines: 2,
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      var _;
                                      if (controller.busPosition == 4) {
                                        _ = await fromBusFun(controller.to);
                                      } else {
                                        ({String text, LatLng latLng})? data = await fromTaxiFun("from");
                                        if (data != null) {
                                          _ = data.text;
                                          controller.fromLatLng = data.latLng;
                                        }
                                      }
                                      if (_ != null) {
                                        setState(() {
                                          controller.from = _;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.ads_click,
                                      color: Colors.blue,
                                    )),
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
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      controller.to ?? "Select To",
                                      maxLines: 2,
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      var _;
                                      if (controller.busPosition == 4) {
                                        _ = await toBusFun();
                                      } else {
                                        ({String text, LatLng latLng})? data = await fromTaxiFun("to");
                                        if (data != null) {
                                          _ = data.text;
                                          controller.toLatLng = data.latLng;
                                        }
                                      }
                                      if (_ != null) {
                                        setState(() {
                                          controller.to = _;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.ads_click,
                                      color: Colors.blue,
                                    )),
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
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(width: 100, child: Text(controller.date ?? "Select Date")),
                                TextButton(
                                    onPressed: () async {
                                      DateTime? selectedValue;
                                      DateTime? _ = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                surfaceTintColor: Colors.white,
                                                title: Container(
                                                  color: Colors.white,
                                                  height: 220,
                                                  width: MediaQuery.sizeOf(context).width / 2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text("Pick Date of Your trip"),
                                                      SizedBox(
                                                        width: 25,
                                                      ),
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
                                                      SizedBox(
                                                        width: 25,
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
                                                              Get.back(result: (selectedValue ?? DateTime.now()));
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
                                                ),
                                              ));
                                      if (_ != null) {
                                        controller.date = _.toString().split(" ")[0];
                                        controller.update();
                                        setState(() {});
                                      }
                                    },
                                    child: Icon(
                                      Icons.ads_click,
                                      color: Colors.blue,
                                    )),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 75,
                          width: 250,
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              print(HiveDataBase.getUserData().name);
                              print(HiveDataBase.getUserData().name != "null");
                              print(controller.from != null && controller.to != null && controller.date != null&&HiveDataBase.getUserData().name != "null");
                              if (controller.from != null && controller.to != null && controller.date != null&&HiveDataBase.getUserData().name != "null") {
                                if (controller.busPosition == 4) {
                                  Get.to(BusBookingScreen());
                                } else {
                                  Get.to(TaxiBookingScreen(from: controller.from!, to: controller.to!, date: controller.date!));
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
            SizedBox(height: 50),
          ],
        );
      }),
    );
  }

  Widget countryPicker(text, selected, setstate, another) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
          decoration: BoxDecoration(color: text == selected ? Colors.blue.withOpacity(0.5) : Colors.transparent, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
                color: text == another
                    ? Colors.grey
                    : text == selected
                        ? Colors.white
                        : Colors.black),
          )),
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
                      Text("Choose your starting location"),
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

  Future<({String text, LatLng latLng})?> fromTaxiFun(ref) async {
    TextEditingController textController = TextEditingController();
    ({String text, LatLng latLng})? address = await showDialog(
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
                            controller: textController,
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
                            onSelected: (name) async {
                              await controller.getPlace(name);
                              Get.back(result: (text: name, latLng: controller.places.places!.map((e) => LatLng(e.location!.latitude!, e.location!.longitude!)).first));
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
                          controller.markers.clear();
                          controller.controller = Completer();
                          controller.controller.complete(_controller);
                          controller.animateCamera(
                            LatLng(25.770223, 55.930957),
                          );
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
                            print(controller.places.places!.first.displayName!.text);
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
                            print(controller.places.places!.first.displayName!.text);
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
                                  Get.back(result: (text: "My Location", latLng: LatLng(position.latitude, position.longitude)));
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
                                  Get.back(result: (text: controller.places.places!.first.displayName!.text, latLng: controller.places.places!.map((e) => LatLng(e.location!.latitude!, e.location!.longitude!)).first));
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
                        Text("Choose your drop off location"),
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
