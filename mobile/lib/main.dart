import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:mapping/model/place.dart';
import 'package:mapping/new_place.dart';
import 'package:mapping/store.dart';

void main() => runApp(new MyApp(PlaceStore()));

class MyApp extends StatelessWidget {
  PlaceStore placeStore;

  MyApp(this.placeStore)

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Maps', store: placeStore),
    );
  }
}

class MyHomePage extends StatefulWidget {
  PlaceStore store;

  MyHomePage({Key key, this.title, this.store}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = new Location();
  MapController controller;

  @override
  void initState() {
    controller = new MapController();
  }

  void _addNew() async {
    var currentLocation = await location.getLocation();
    var latLng =
        LatLng(currentLocation['latitude'], currentLocation['longitude']);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateNewPlacePage(latLng, widget.store)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: StreamBuilder<Map<String, double>>(
          stream: location.onLocationChanged(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, double>> locationSnapshot) {
            final locationMarker = locationSnapshot.data != null
                ? buildLocationMarker(locationSnapshot.data)
                : null;

            final markerLayer = MarkerLayerOptions(
              markers: [locationMarker],
            );

            return FlutterMap(
                mapController: controller,
                options: new MapOptions(
                    center: new LatLng(33.7661, -84.3726), zoom: 13.0),
                layers: [buildTileLayer(), markerLayer]);
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addNew,
        tooltip: 'Add New',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TileLayerOptions buildTileLayer() {
    return new TileLayerOptions(
      urlTemplate: "https://api.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken':
            'pk.eyJ1Ijoibmlja21hdGhld3MiLCJhIjoiY2ptODAzYjl1MTFjeDNrbjNyMjFhbzNwNiJ9.Hxvb82fQzFlflszFKqP1RA',
        'id': 'mapbox.streets',
      },
    );
  }

  Marker buildPlaceMarker(Place data) {
    return new Marker(
        point: data.location,
        builder: (context) => new Container(
              child: new Icon(
                Icons.location_on,
                color: Color.fromRGBO(0, 255, 0, 1.0),
                size: 50.0,
              ),
            ));
  }

  Marker buildLocationMarker(Map<String, double> data) {
    return new Marker(
        point: LatLng(data["latitude"], data["longitude"]),
        builder: (context) => new Container(
              child: new Icon(
                Icons.fiber_manual_record,
                color: Color.fromRGBO(0, 0, 255, 1.0),
              ),
            ));
  }
}
