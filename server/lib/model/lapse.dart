import '../lapse_server.dart';

class Lapse extends ManagedObject<_Lapse> implements _Lapse {}

class _Lapse {
  @primaryKey
  int id;

  double latitude;
  double longitude;
  String description;

//  ManagedSet<LapsePhoto> photos;
}
