import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/map_screen.dart';
import '../helpers/location_helper.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final previewUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = previewUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await Location().getLocation();
      _showPreview(location.latitude, location.longitude);

      widget.onSelectPlace(location.latitude, location.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => MapScreen(isSelecting: true)));

    if (selectedLocation == null) return;

    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
                onPressed: _getCurrentLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Location'),
                textColor: Theme.of(context).primaryColor),
            FlatButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text('Select on Map'),
                textColor: Theme.of(context).primaryColor),
          ],
        ),
      ],
    );
  }
}
