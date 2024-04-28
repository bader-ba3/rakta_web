import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../model/Place_model.dart';
import '../utils/utils.dart';

class HomeController extends GetxController{
  double busPosition = 4;
  double carPosition = 1.1;
  ScrollController scrollController = ScrollController();
  String? from ,to,date;
  LatLng? fromLatLng;
  LatLng? toLatLng;

  void changeToBus() {
    busPosition = 4;
    carPosition = 1.1;
    from = null;
    to = null;
    date = null;
    update();
  }
  Completer<GoogleMapController> controller = Completer();

  Future<void> animateCamera(LatLng location) async {
    final GoogleMapController controller = await this.controller.future;
    CameraPosition cameraPosition = CameraPosition(
      bearing: 0,

      target: location,
      zoom: 17.00,
    );
    // print(
    //     "animating camera to (lat: ${location.latitude}, long: ${location.longitude})");
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void changeToTaxi() {
    busPosition = 1.1;
    carPosition = 2.7;
    from = null;
    to = null;
    date = null;
    update();
  }

  Set<Marker> markers = {};
  LatLng? userPosition;
  void setMarker(LatLng location, String path, String uID,String bearing,{int? size}) {
    Utils()
        .getBytesFromAsset(path: 'images/$path.png', width: size??100)
        .then((value) {
      Marker newMarker = Marker(
        markerId: MarkerId(uID),
        icon: BitmapDescriptor.fromBytes(value),
        position: location,
        rotation: double.parse(bearing),
        onTap: () {},
      );
      markers.add(
        newMarker,
      );
      update();
    });
  }


  PlaceModel places = PlaceModel();


  Future<List<String>> getPlace(String placeText) async {
    Map<String, dynamic> body = {
      "textQuery": placeText,
    };
    Map<String, String> headers = {
      "Accept": "*/*",
      "X-Goog-Api-Key": "AIzaSyDI6RQ6KLpxiQEtyTLlUmxH4Osm4A7Zhcg",
      "X-Goog-FieldMask":
      "places.displayName,places.formattedAddress,places.priceLevel,places.location"
    };

    http.Response response = await http.post(
        Uri.parse("https://places.googleapis.com/v1/places:searchText"),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      print(places.places?.map((e) => e.displayName!.text!).toList());
      places = PlaceModel.fromJson(jsonDecode(response.body));
      return places.places!.map((e) => e.displayName!.text!).toList() ??[];

    } else {
      return [];
    }
  }

  Future<void> getLocationName(LatLng location) async {
    String body = jsonEncode({
      "maxResultCount": "1",
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": location.latitude,
            "longitude": location.longitude
          },
          "radius": 50.0
        }
      }
    });
    Map<String, String> headers = {
      "Accept": "*/*",
      "X-Goog-Api-Key": "AIzaSyDI6RQ6KLpxiQEtyTLlUmxH4Osm4A7Zhcg",
      "X-Goog-FieldMask":
      "places.displayName,places.formattedAddress,places.priceLevel,places.location"
    };

    http.Response response = await http.post(
        Uri.parse("https://places.googleapis.com/v1/places:searchNearby"),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      places = PlaceModel.fromJson(jsonDecode(response.body));
    } else {

    }
  }

  Future<Polyline> drawPolyline(LatLng from, LatLng to, String tpId) async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyDI6RQ6KLpxiQEtyTLlUmxH4Osm4A7Zhcg",
          PointLatLng(from.latitude, from.longitude),
          PointLatLng(to.latitude, to.longitude));
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      // List<LocationModel> location = [];
      // for (var loc in polylineCoordinates) {
      //   location.add(LocationModel(location: loc));
      // }
      // Get.find<TripViewModel>()
      //     .editTrip(TripModel(tpId: tpId, tpPolyLine: location));

      return Polyline(
          polylineId: PolylineId("polyline_id ${result.points.length}"),
          color: const Color(0xff0f3b7f),
          points: polylineCoordinates,
          consumeTapEvents: true,);
    } on Exception catch (e) {
      print(e.toString());
      Get.snackbar("Error with path", e.toString());

      throw Exception();
    }
  }
}