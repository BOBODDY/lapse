import 'dart:io';

import 'package:latlong/latlong.dart';

class Place {
  String name = "";
  File image;
  
  LatLng location;


  Place(this.name, this.image, this.location);

  Place.fromMap(Map<String, dynamic> map) {
    name = map["name"];
  }
}
