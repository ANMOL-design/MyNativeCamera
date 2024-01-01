// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_location_picker/models/place.dart';
import 'package:image_location_picker/screens/map.dart';
import 'package:location/location.dart';
// import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  // Making a Funciton to show the Location on Map Using Google Static API
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    // final lat = _pickedLocation!.latitiude;
    // final lng = _pickedLocation!.longitude;

    // Map API
    return 'https://www.google.com/maps/d/thumbnail?mid=1xBGkX5K7_o1tYGP3mDAhtuCx8hQ&hl=en_US';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    const address = "277 Bedford Avenue, Brooklyn, NY 11211, USA";

    savePlace(lat, lng, address);
  }

  void savePlace(double latitude, double longitude, String address) {
    // Make an APi call and send request to Google
    // GeoCode api to Show Location
    // final url = Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBe30xLd9Z77KEOVG75EOW1qcIZOoJbv6Y');

    // final response = await http.get(url);
    // final data = json.decode(response.body);
    // final address = data['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
        latitiude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    // Saving the Location
    widget.onSelectLocation(_pickedLocation!);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<PlaceLocation>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    savePlace(pickedLocation.latitiude, pickedLocation.longitude,
        pickedLocation.address);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location Choosen.",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 180,
          width: double.infinity,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
