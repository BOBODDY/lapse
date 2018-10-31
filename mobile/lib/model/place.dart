import 'dart:io';

import 'package:latlong/latlong.dart';

class Place {
  String name = "";
  File image;

  LatLng location;

  Place(this.name, this.image, this.location);

  Place.fromMap(Map<String, dynamic> map) {
    name = map["name"];

    var lat = map["latitude"];
    var long = map["longitude"];
    location = LatLng(lat, long);
  }

  Map<String, dynamic> asMap() {
    return {
      "name": name,
      "latitude": location.latitude,
      "longitude": location.longitude,
      // TODO: figure out how the images are being savee
    };
  }
}
