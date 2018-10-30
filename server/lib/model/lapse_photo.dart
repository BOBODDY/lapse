import 'package:lapse_server/model/lapse.dart';

import '../lapse_server.dart';

class LapsePhoto extends ManagedObject<_LapsePhoto> implements _LapsePhoto {}

class _LapsePhoto {
  @primaryKey
  int id;

  DateTime date;
  String image; // URL where image is stored

  @Relate(#photos)
  Lapse lapse;
}
