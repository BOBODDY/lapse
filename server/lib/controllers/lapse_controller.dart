import 'package:lapse_server/model/lapse.dart';
import 'package:latlong/latlong.dart' as DistanceLatLong;
import 'package:latlong/latlong.dart';

import '../lapse_server.dart';

class LapseController extends ManagedObjectController<Lapse> {
  final ManagedContext context;

  LapseController(this.context) : super(context);

  @Operation.get()
  Future<Response> getNearbyCities(@Bind.body() LatLng latLng) async {
    final locations = await Query<Lapse>(context).fetch();
    final List<Lapse> filteredLocations = locations.where((location) {
      final locationLatLng = LatLng(location.latitude, location.longitude);

      final distance = DistanceLatLong.Distance()
          .as(DistanceLatLong.LengthUnit.Kilometer, locationLatLng, latLng);

      return distance <= 100; // TODO: Figure out the return value of
    });
    return Response.ok(filteredLocations);
  }
}
