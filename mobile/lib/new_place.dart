import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:mapping/model/place.dart';
import 'package:mapping/store.dart';

class CreateNewPlacePage extends StatefulWidget {
  final String title = "New Place";
  LatLng location;
  PlaceStore store;

  CreateNewPlacePage(this.location, this.store);

  @override
  State<StatefulWidget> createState() => _CreateNewPlacePageState();
}

class _CreateNewPlacePageState extends State<CreateNewPlacePage> {
  File _imageFile;

  String _newPlaceName;

  void _addNewPlace() async {
    var place = Place(_newPlaceName, _imageFile, widget.location);
    bool submitted = await widget.store.addNewPlace(place);

    print(_newPlaceName);
    if (submitted) {
      goBack();
    } else {
      // TODO: show an error
    }
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              createStaticMap(),
              Container(
                margin: EdgeInsets.only(top: 150.0),
                child: Align(
                  child: Card(
                    child: FlatButton(
                      child: createImage(),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (newText) => _newPlaceName = newText,
              decoration: InputDecoration(hintText: "Name this place"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: RaisedButton(
              onPressed: _addNewPlace,
              child: Text("Submit"),
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
        options:
            MapOptions(center: widget.location, zoom: 16.0, interactive: false),
        layers: [buildTileLayer(), locationLayer],
      ),
    );
  }

  Image createImage() {
    return _imageFile != null
        ? Image.file(
            _imageFile,
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          )
        : Image.network(
            "https://hacktoberfest.digitalocean.com/assets/icon-who-df656b71ff28fed039a356122040ff7e4aa18e72c381c078869a7841d549d99f.png",
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover);
  }

  TileLayerOptions buildTileLayer() {
    return TileLayerOptions(
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
    return Marker(
        point: location,
        builder: (context) => Container(
              child: Icon(
                Icons.location_on,
                color: Color.fromRGBO(255, 0, 0, 1.0),
              ),
            ));
  }
}
