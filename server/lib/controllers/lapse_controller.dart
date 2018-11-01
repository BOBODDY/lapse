import 'package:lapse_server/model/lapse.dart';
import 'package:latlong/latlong.dart' as DistanceLatLong;
import 'package:latlong/latlong.dart';

import '../lapse_server.dart';

class LapseController extends ResourceController {
  final ManagedContext context;

  LapseController(this.context);

  @Operation.get()
  Future<Response> getNearbyCities(@Bind.query("lat") double latitude,
      @Bind.query("long") double longitude) async {
    if (latitude == null || longitude == null) {
      return Response.badRequest();
    }

    final comparison = LatLng(latitude, longitude);

    final locations = await Query<Lapse>(context).fetch();
    final List<Lapse> filteredLocations = locations.where((location) {
      final locationLatLng = LatLng(location.latitude, location.longitude);

      final distance = DistanceLatLong.Distance()
          .as(DistanceLatLong.LengthUnit.Kilometer, locationLatLng, comparison);

      return distance <= 50; // TODO: Figure out the return value of
    }).toList();
    return Response.ok(filteredLocations);
  }
}
