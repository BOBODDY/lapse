import 'package:lapse_server/model/lapse.dart';

import '../lapse_server.dart';

class LapsePhoto extends ManagedObject<_LapsePhoto> implements _LapsePhoto {}

class _LapsePhoto {
  @primaryKey
  int id;

  DateTime date;
  String image;

  @Relate(#photos, onDelete: DeleteRule.cascade, isRequired: true)
  Lapse lapse;
}
