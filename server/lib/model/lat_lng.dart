
import 'package:lapse_server/lapse_server.dart';

class LatLng extends Serializable {
  double latitude;
  double longitude;

  @override
  Map<String, double> asMap() {
    return {
      'latitude': latitude,
      'longitude': longitude
    };
  }

  @override
  void readFromMap(Map<String, dynamic> map) {
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;
  }

}