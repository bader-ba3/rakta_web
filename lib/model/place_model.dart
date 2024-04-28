// ignore_for_file: file_names

class PlaceModel {
  List<Places>? places = [];

  PlaceModel({this.places});

  PlaceModel.fromJson(Map<String, dynamic> json) {
    if (json['places'] != null) {
      places = <Places>[];
      json['places'].forEach((v) {
        places!.add(Places.fromJson(v));
      });
    }
  }
}

class Places {
  String? formattedAddress;
  Location? location;
  DisplayName? displayName;

  Places({this.formattedAddress, this.location, this.displayName});

  Places.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formattedAddress'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    displayName = json['displayName'] != null
        ? DisplayName.fromJson(json['displayName'])
        : null;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class DisplayName {
  String? text;
  String? languageCode;

  DisplayName({this.text, this.languageCode});

  DisplayName.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }
}
