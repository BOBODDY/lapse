import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapping/model/place.dart';

class CreateNewPlacePage extends StatefulWidget {
  final String title = "New Place";
  LatLng location;

  CreateNewPlacePage(this.location);

  @override
  State<StatefulWidget> createState() => new _CreateNewPlacePageState();
}

class _CreateNewPlacePageState extends State<CreateNewPlacePage> {
  File imageFile;

  String newPlaceName;

  void _addNewPlace() {
    var place = Place(newPlaceName, imageFile, widget.location);
    // TODO: send this somewhere
    print(newPlaceName);
    goBack();
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              createStaticMap(),
              Container(
                margin: EdgeInsets.only(top: 150.0),
                child: new Align(
                  child: Card(
                    child: createImage(),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: new TextField(
              onChanged: (newText) => newPlaceName = newText,
              decoration: InputDecoration(hintText: "Name this place"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: new RaisedButton(
              onPressed: _addNewPlace,
              child: new Text("Submit"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget createStaticMap() {
    final locationLayer = MarkerLayerOptions(
      markers: widget.location != null
          ? <Marker>[buildLocationMarker(widget.location)]
          : <Marker>[],
    );

    return Container(
      height: 200.0,
      child: FlutterMap(
        options: new MapOptions(
            center: widget.location, zoom: 13.0, interactive: false),
        layers: [buildTileLayer(), locationLayer],
      ),
    );
  }

  Image createImage() {
    return imageFile != null
        ? Image.file(
            imageFile,
            height: 100.0,
            width: 100.0,
          )
        : Image.network(
            "https://hacktoberfest.digitalocean.com/assets/icon-who-df656b71ff28fed039a356122040ff7e4aa18e72c381c078869a7841d549d99f.png",
            height: 100.0,
            width: 100.0,
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

  Marker buildLocationMarker(LatLng location) {
    return new Marker(
        point: location,
        builder: (context) => new Container(
              child: new Icon(
                Icons.location_on,
                color: Color.fromRGBO(255, 0, 0, 1.0),
              ),
            ));
  }
}
