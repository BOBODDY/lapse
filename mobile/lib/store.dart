import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mapping/model/place.dart';

class PlaceStore {
  static const _baseUrl = "127.0.0.1"; // TODO: replace with real URL
  // TODO: add auth

  Future<List<Place>> getPlaces() async {
    try {
      var response = await get(_baseUrl + "/lapses");
      // TODO: add headers with auth token

      List body = json.decode(response.body);
      if (response.statusCode == 200) {
        var places = body.map((x) => Place.fromMap(x)).toList();
        return places;
      }
    } catch (e) {
      print("error getting places: $e");
    }

    return [];
  }

  Future<bool> addNewPlace(Place place) async {
    try {
      var response =
          await post(_baseUrl + "/lapses", body: json.encode(place.asMap));
      // TODO: add headers with auth token

      return response.statusCode == 200;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
