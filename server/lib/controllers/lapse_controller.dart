import 'package:lapse_server/model/lapse.dart';
import 'package:lapse_server/model/lat_lng.dart';

import '../lapse_server.dart';

class LapseController extends ManagedObjectController<Lapse> {
  LapseController(ManagedContext context) : super(context);

  @Operation.get()
  Future<Response> getNearbyCities(@Bind.body() LatLng latLng) async {
    //TODO: get cities within certain distance
    return Response.ok(null);
  }
}